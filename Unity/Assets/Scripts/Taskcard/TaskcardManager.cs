using System;
using System.Collections;
using System.Collections.Generic;
using Firebase.Firestore;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;

public class TaskcardManager : MonoBehaviour
{
    //GameObjects
    private GameObject _currentHp;
    
    //Scripts
    private TMP_InputField _inputField;
    private TMP_Text _dueDate;
    private RectTransform _currentHpTransform;
    private CurrentHealthChanger _currentHpChanger;
    
    private void Start()
    {
        _currentHp = GameObject.Find("CurrentHp");
        _inputField = GameObject.Find("TaskNameInputField").GetComponent<TMP_InputField>();
        _dueDate = GameObject.Find("DueDate").GetComponent<TMP_Text>();
    }

    private void SetTaskData(DocumentSnapshot taskSnapshot)
    {
        Dictionary<string, object> taskDocument = taskSnapshot.ToDictionary();

        _inputField.text = (string)taskDocument["name"];
        
        float currentHpScale = (float)taskDocument["currentHealth"] / (float)taskDocument["maxHealth"];
        _currentHpTransform.localScale = new Vector3(currentHpScale, 1.0f, 1.0f);
        _currentHpChanger.OnDataChanged(currentHpScale);
        
        string dueDate = (string)taskDocument["dueDate"];
        dueDate = "Due:\n  " + dueDate.Split("/")[0];
        _dueDate.text = dueDate;

    }
}
