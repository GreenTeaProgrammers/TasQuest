using System;
using System.Collections.Generic;
using System.Linq;
using Firebase.Firestore;
using TMPro;
using UnityEngine;

public class TaskcardManager : MonoBehaviour
{
    //Mode
    private static bool isEditMode = false;
    
    //GameObjects
    private GameObject _currentHp;
    
    //Scripts
    private static InputFieldManager _inputFieldManager;
    private static TMP_Text _dueDate;
    private RectTransform _currentHpTransform;
    private static CurrentHealthChanger _currentHpChanger;
    private static HpTextManager _hpTextManager;
    
    //
    private static List<DocumentSnapshot> _taskList;
    
    private void Start()
    {
        _currentHp = GameObject.Find("CurrentHp");
        _inputFieldManager = GameObject.Find("TaskNameInputField").GetComponent<InputFieldManager>();
        _dueDate = GameObject.Find("DueDate").GetComponent<TMP_Text>();
        _currentHpTransform = _currentHp.GetComponent<RectTransform>();
        _currentHpChanger = _currentHp.GetComponent<CurrentHealthChanger>();
        _hpTextManager = GameObject.Find("HpText").GetComponent<HpTextManager>();
     }

    public static void OnGoalChanged()
    {
        PreprocessTaskData(User.TasksSnapshot);
        DocumentSnapshot taskDocument = _taskList[0];
        SetTaskDataDisplay(taskDocument);
    }

    /// <summary>
    /// メインカメラの位置にを監視してタスクカードに書き込むべきタスクを_taskListから取り出す。
    /// currentIndexがout of rangeの時には呼ばれないように監視している。
    /// </summary>
    /// <param name="currentIndex"></param>
    public static void OnCurrentTaskChanged(int currentIndex)
    {
        SetTaskDataDisplay(_taskList[currentIndex]);
    }

    /// <summary>
    /// タスクのデータを書き換えたときに呼ばれます
    /// </summary>
    /// <param name="key"></param>
    /// <param name="data"></param>
    /// <exception cref="SystemException"></exception>
    public static async System.Threading.Tasks.Task OnTaskDataChanged(string key, object data)
    {
        DocumentSnapshot taskData = _taskList[CameraMovement.CurrentIndex];
        Dictionary<string, object> taskDocument = taskData.ToDictionary();
        Debug.Log($"{key}に{data}をかきこみました");
        try
        {
            taskDocument[key] = data;
            await User.fireStoreManager.UpdateTask(taskData.Id, taskDocument);
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw new SystemException("Key is Invalid");
        }
        
    }
    
    private static void PreprocessTaskData(QuerySnapshot tasksSnapshot)
    {
        _taskList = tasksSnapshot.Documents.ToList();
    }
        
    /// <summary>
    /// DocumentSnapshotを引数に受け取り、その値をもとにTaskcardの内容を書き換える関数です。
    /// </summary>
    /// <param name="taskSnapshot"></param>
    private static void SetTaskDataDisplay(DocumentSnapshot taskSnapshot)
    {
        Dictionary<string, object> taskDocument = taskSnapshot.ToDictionary();

        _inputFieldManager.UpdateTaskName((string)taskDocument["name"]);
        
        var currentHealth = (float) Convert.ChangeType(taskDocument["currentHealth"], typeof(float));
        var maxHealth = (float)Convert.ChangeType(taskDocument["maxHealth"], typeof(float));
        
        _currentHpChanger.OnHealthChanged(currentHealth, maxHealth);
        
        _hpTextManager.OnHealthChanged(currentHealth, maxHealth);
        
        Timestamp dueDate = (Timestamp) Convert.ChangeType(taskDocument["dueDate"], typeof(Timestamp));
        string dueDateText = dueDate.ToDateTime().ToString();
        dueDateText = "Due:\n" + dueDateText.Split()[0];
        _dueDate.text = dueDateText;
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
    /// モードに従ってピンチ操作がなされた際に、currentHpかmaxHpを変動させます。
    /// </summary>
    public void PinchControl(float pinchDistance)
    {
        if (isEditMode)
        {
            //maxHpを変化させる
            _currentHpChanger.PinchMaxHealth(pinchDistance);
        }
        else
        {
            //currentHpを変化させる
            _currentHpChanger.PinchCurrentHealth(pinchDistance);
        }
    }
    
    /// <summary>
    /// 現在のモードを参照できます
    /// </summary>
    /// <returns></returns>
    public static bool IsEditMode
    {
        get { return isEditMode; }
        set { isEditMode = value; }
    }
}
