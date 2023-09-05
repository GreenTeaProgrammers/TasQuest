using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using JetBrains.Annotations;

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
    public string names;
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

public class JsonManager
{
    public JsonData inputJson;
    private const string JSON_PATH = "";
    
    //コンストラクタでjsonを読み込む
    public JsonManager()
    {
        StreamReader streamReader;
        streamReader = new StreamReader(JSON_PATH);
        // string inputString = Resources.Load<TextAsset>("input").ToString();
        string inputString = streamReader.ReadToEnd();
        streamReader.Close();
        
        inputJson = JsonUtility.FromJson<JsonData>(inputString);
    }

    //json書き込み関数
    public static void WriteJson(JsonData input)
    {
        StreamWriter streamWriter;
        string jsonString = JsonUtility.ToJson(input);

        streamWriter = new StreamWriter(JSON_PATH, false);
        streamWriter.Write(jsonString);
        streamWriter.Flush();
        streamWriter.Close();
    }
}
