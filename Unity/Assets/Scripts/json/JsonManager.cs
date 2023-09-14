using System;
using UnityEngine;
using System.IO;
using UnityEngine.UIElements;


[Serializable]
public class AppData
{
    public string createdAt;  // YYYY-MM-DD/HH:MM:SS
    public Status[] statuses;
    public Tag[] tags;
    public string userid;
    public string username;
}

[Serializable]
public class Status
{
    public string id;
    public string updatedAt; // YYYY-MM-DD/HH:MM:SS
    public string name;
    public Goal[] goals;
}

[Serializable]
public class Goal
{
    public string createdAt;  // YYYY-MM-DD/HH:MM:SS
    public Tag[] tags;
    public TasQuestTask[] tasks;
    public string name;
    public bool isStarred;
    public string updatedAt;  // YYYY-MM-DD/HH:MM:SS
    public string description;
    public string id;
    public string thumbnail;
    public string dueDate;  // YYYY-MM-DD/HH:MM:SS
}

[Serializable]
public class TasQuestTask
{
    public string dueDate;  // YYYY-MM-DD/HH:MM:SS
    public bool isVisible;
    public Tag[] tags;
    public string createdAt;  // YYYY-MM-DD/HH:MM:SS
    public float currentHealth;
    public string description;
    public string id;
    public string updatedAt;  // YYYY-MM-DD/HH:MM:SS
    public string name;
    public float maxHealth;
}

[Serializable]
public class Tag
{
    public int id;
    public string name;
    public float[] color;
    public string createdAt;  // YYYY-MM-DD/HH:MM:SS
    public string updatedAt;  // YYYY-MM-DD/HH:MM:SS
}

//jsonの読み書きを担当するクラス。実際にjsonのデータを扱うわけではない。
public class JsonManager
{
    //開発用パス。本番環境ではデータはFireBaseから引く。
    private const string JSON_PATH = "Assets/Resources/AppData.json";
    
    //jsonを読み込んでAppDataクラスのデータを返す。
    public static AppData LoadJson(string path=JSON_PATH)
    {
        try
        {
            StreamReader streamReader;
            streamReader = new StreamReader(path);
            string jsonDataString = streamReader.ReadToEnd();
            streamReader.Close();

            AppData jsonData = JsonUtility.FromJson<AppData>(jsonDataString);
            return jsonData;
        }
        catch (Exception e)
        {
            Debug.Log(e.Message);
            Debug.Log("Error occurred on reading JSON file");
            CallErrorUI();
        }

        return null;
    }

    //json書き込み関数
    //引数はjsonDataクラスのオブジェクトと保存パス
    //デフォルトはAssets/Resources/Appdata.json
    public static void SaveJson(AppData jsonData, string path=JSON_PATH)
    {
        try
        {
            StreamWriter streamWriter;
            string jsonDataString = JsonUtility.ToJson(jsonData);

            streamWriter = new StreamWriter(path, false);
            streamWriter.Write(jsonDataString);
            streamWriter.Flush();
            streamWriter.Close();
        }
        catch (Exception e)
        {
            Debug.Log(e.Message);
            Debug.Log("Error occurred on writing JSON file");
            CallErrorUI();
        }
    }

    //StringからAppDataに変換
    public static AppData String2Json(string jsonDataString)
    {
        AppData jsonData = JsonUtility.FromJson<AppData>(jsonDataString);
        return jsonData;
    }
    
    //AppDataからStringに変換
    public static String Json2String(AppData jsonData)
    {
        string jsonDataString = JsonUtility.ToJson(jsonData);
        return jsonDataString;
    }
    
    //エラーが発生した際、その旨を表示するUIを呼び出します。
    //UIがまだ作成されていないので関数の中身は未着手です。
    private static void CallErrorUI()
    {
        Debug.Log("Call error UI");
    }

    public static void UpdateTaskData(TasQuestTask taskData)
    {
        string taskID = taskData.id;
        string goalID = User.GoalData.id;
        string statusID = User.StatusData.id;

        int statusIndex = 0;
        int goalIndex = 0;
        int taskIndex = 0;
        foreach (var status in User.UserData.statuses)
        {
            if (status.id == statusID)
            {
                foreach (var goal in status.goals)
                {
                    if (goal.id == goalID)
                    {
                        foreach (var task in goal.tasks)
                        {
                            if (task.id == taskID)
                            {
                                User.UserData.statuses[statusIndex].goals[goalIndex].tasks[taskIndex] = taskData;
                                User.StatusData = User.UserData.statuses[statusIndex];
                                User.GoalData = User.StatusData.goals[goalIndex];
                            }
                            taskIndex++;
                        }
                    }
                    goalIndex++;
                }
            }
            statusIndex++;
        }
        
        DataExchanger.SendAppData();
        //test
        // SaveJson(User.UserData, "Assets/Resources/AppDataTest.json");
    }
}
