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
    //開発用パス。本番環境ではデータはFireBaseから引く。
    private const string JSON_PATH = "Assets/Resources/AppData.json";
    
    //jsonを読み込んでAppDataクラスのデータを返す。
    //引数pathでロードするJSONのパスが指定できるようになりました
    public AppData LoadJson(string path=JSON_PATH)
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
    public void SaveJson(AppData jsonData, string path=JSON_PATH)
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
    public AppData String2Json(string jsonDataString)
    {
        AppData jsonData = JsonUtility.FromJson<AppData>(jsonDataString);
        return jsonData;
    }
    
    //AppDataからStringに変換
    public String Json2String(AppData jsonData)
    {
        string jsonDataString = JsonUtility.ToJson(jsonData);
        return jsonDataString;
    }
    
    //エラーが発生した際、その旨を表示するUIを呼び出します。
    //UIがまだ作成されていないので関数の中身は未着手です。
    private void CallErrorUI()
    {
        Debug.Log("Call error UI");
    }
}
