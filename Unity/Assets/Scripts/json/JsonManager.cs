using System;
// using System.Collections;
// using System.Collections.Generic;
using UnityEngine;
using System.IO;


//class名要検討 どんなデータなのか分かる名前だとよい
[Serializable]
public class JsonData
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
    public string updatedAt;
}

[Serializable]
public class Goal
{
    public int id;
    public string name;
    public string description;
    public string createdAt;
    public string updatedAt;
    public string dueDate;
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
    public float maxHealth;
    public float currentHealth;
    public Tag[] tags;
    public bool isVisible;
    public string createdAt;
    public string updatedAt;
}

[Serializable]
public class Tag
{
    public int id;
    public string name;
    public float[] color;
    public string createdAt;
    public string updatedAt;
}

//jsonの読み書きを担当するクラス。実際にjsonのデータを扱うわけではない。
public class JsonManager
{
    //まだダミーのjsonファイルのパスです。本番環境で変えます。
    private const string JSON_PATH = "Assets/Resources/DummyJson.json";
    
    //コンストラクタでjsonを読み込む予定だったがLoadJsonメソッドに置き換えた。
    //LoadとSaveが対照のほうが容易と思ったので
    // public JsonManager()
    
    //jsonを読み込んでJsonDataクラスのデータを返す。
    //おいおいは引数にパスを取る
    public JsonData LoadJson()
    {
        try
        {
            StreamReader streamReader;
            streamReader = new StreamReader(JSON_PATH);
            string jsonDataString = streamReader.ReadToEnd();
            streamReader.Close();

            JsonData jsonData = JsonUtility.FromJson<JsonData>(jsonDataString);
            return jsonData;
        }
        catch (Exception e)
        {
            Debug.Log(e.Message);
            Debug.Log("Error occurred on reading JSON file");
        }

        return null;
    }

    //json書き込み関数
    //引数はjsonDataクラスのオブジェクト
    public void SaveJson(JsonData jsonData)
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
        }
    }
}
