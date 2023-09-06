using System;
using UnityEngine;
using System.IO;


[Serializable]
public class AppData
{
    public Status[] statuses;
    public Tag[] tags;
}

[Serializable]
public class Status
{
    public int id;
    public string name;
    public Goal[] goals;
    public string updatedAt; // YYYY-MM-DD/HH:MM:SS
}

[Serializable]
public class Goal
{
    public int id;
    public string name;
    public string description;
    public string createdAt;  // YYYY-MM-DD/HH:MM:SS
    public string updatedAt;  // YYYY-MM-DD/HH:MM:SS
    public string dueDate;  // YYYY-MM-DD/HH:MM:SS
    public Tag[] tags;
    public string thumbnail;
    public bool isStarred;
    // public int layoutId;
    public Task[] tasks;
    public int currentTaskIndex;
}

[Serializable]
public class Task
{
    public int id;
    public string name;
    public string description;
    public string dueDate;  // YYYY-MM-DD/HH:MM:SS
    public float maxHealth;
    public float currentHealth;
    public Tag[] tags;
    public bool isVisible;
    public string createdAt;  // YYYY-MM-DD/HH:MM:SS
    public string updatedAt;  // YYYY-MM-DD/HH:MM:SS
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
    //まだダミーのjsonファイルのパスです。本番環境で変えます。
    private const string JSON_PATH = "Assets/Resources/DummyJson.json";
    
    //jsonを読み込んでAppDataクラスのデータを返す。
    //おいおいは引数にパスを取る
    public AppData LoadJson()
    {
        try
        {
            StreamReader streamReader;
            streamReader = new StreamReader(JSON_PATH);
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
    //引数はjsonDataクラスのオブジェクト
    public void SaveJson(AppData jsonData)
    {
        try
        {
            StreamWriter streamWriter;
            string jsonDataString = JsonUtility.ToJson(jsonData);

            streamWriter = new StreamWriter(JSON_PATH, false);
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

    //エラーが発生した才、その旨を表示するUIを呼び出します。
    //UIがまだ作成されていないので関数の中身は未着手です。
    private void CallErrorUI()
    {
        Debug.Log("Call error UI");
    }
}
