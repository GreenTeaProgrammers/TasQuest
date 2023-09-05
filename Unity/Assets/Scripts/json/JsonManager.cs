using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class InputJson
{
    public Status[] status;
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

public class Tag
{
    public int id;
    public string name;
    public float[] color;
    public string createdAt;
    public string updatedAt;
}

public class JsonManager : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        string inputString = Resources.Load<TextAsset>("input").ToString();
        InputJson inputJson = JsonUtility.FromJson<InputJson>(inputString);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
