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
    private TMP_InputField _inputField;
    private TMP_Text _dueDate;
    private RectTransform _currentHpTransform;
    private CurrentHealthChanger _currentHpChanger;
    private HpTextManager _hpTextManager;
    
    //
    private List<DocumentSnapshot> _taskList;
    
    private async void Start()
    {
        _currentHp = GameObject.Find("CurrentHp");
        _inputField = GameObject.Find("TaskNameInputField").GetComponent<TMP_InputField>();
        _dueDate = GameObject.Find("DueDate").GetComponent<TMP_Text>();
        _currentHpTransform = _currentHp.GetComponent<RectTransform>();
        _currentHpChanger = _currentHp.GetComponent<CurrentHealthChanger>();
        _hpTextManager = GameObject.Find("HpText").GetComponent<HpTextManager>();
        
        // await InitializeTaskcard();
    }

    public void OnGoalChanged()
    {
        
    }

    public void OnTaskChanged()
    {
        
    }
    
    /// <summary>
    /// Taskcardの子のUIすべてをイニシャライズする関数です。
    /// 
    /// </summary>
    private async System.Threading.Tasks.Task InitializeTaskcard()
    {
        //Test
        User.SetUserID("RCGhBVMyFfaUIx7fwrcEL5miTnW2");
        QuerySnapshot tasksSnapshot = await User.fireStoreManager.ReadTasks();
        var e = tasksSnapshot.Documents.GetEnumerator();
        e.MoveNext();
        DocumentSnapshot taskDocument = (DocumentSnapshot)e.Current;
        SetTaskDataDisplay(taskDocument);
    }

    private void PreprocessTaskData(QuerySnapshot tasksSnapshot)
    {
        _taskList = tasksSnapshot.Documents.ToList();
    }
        
    /// <summary>
    /// DocumentSnapshotを引数に受け取り、その値をもとにTaskcardの内容を書き換える関数です。
    /// </summary>
    /// <param name="taskSnapshot"></param>
    private void SetTaskDataDisplay(DocumentSnapshot taskSnapshot)
    {
        Dictionary<string, object> taskDocument = taskSnapshot.ToDictionary();

        _inputField.text = (string)taskDocument["name"];
        
        // var currentHealth = (int)taskDocument["currentHealth"];
        var currentHealth = (float) Convert.ChangeType(taskDocument["currentHealth"], typeof(float));
        var maxHealth = (float)Convert.ChangeType(taskDocument["maxHealth"], typeof(float));
        
        _currentHpChanger.OnHealthChanged(currentHealth, maxHealth);
        
        _hpTextManager.OnHealthChanged(currentHealth, maxHealth);
        
        string dueDate = (string)taskDocument["dueDate"];
        dueDate = "Due:\n" + dueDate.Split("/")[0];
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
