using System.Collections.Generic;
using Firebase.Firestore;
using TMPro;
using UnityEngine;
using UnityEngine.UIElements;

public class TaskcardManager : MonoBehaviour
{
    //Mode
    private static bool isEditMode = false;
    
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
        _currentHpTransform = _currentHp.GetComponent<RectTransform>();
        _currentHpChanger = _currentHp.GetComponent<CurrentHealthChanger>();
    }

    /// <summary>
    /// DocumentSnapshotを引数に受け取り、その値をもとにTaskcardの内容を書き換える関数です。
    /// </summary>
    /// <param name="taskSnapshot"></param>
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

    /// <summary>
    /// モードを変更する関数です。
    /// 現在のモードではないモードになります。
    /// </summary>
    public void ChangeMode()
    {
        isEditMode = !isEditMode;
        Debug.Log($"isEditMode: {isEditMode}");
    }

    /// <summary>
    /// 現在のモードを参照できます
    /// </summary>
    /// <returns></returns>
    public static bool GetMode()
    {
        return isEditMode;
    }
}
