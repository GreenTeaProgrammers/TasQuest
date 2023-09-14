using TMPro;
using UnityEngine;

public class TaskcardManager : MonoBehaviour
{
    //Mode
    private static bool _isEditMode;
    
    //GameObjects
    private GameObject _currentHp;
    
    //Scripts
    private static InputFieldManager _inputFieldManager;
    private static TMP_Text _dueDate;
    private static CurrentHealthChanger _currentHpChanger;
    private static HpTextManager _hpTextManager;
    
    private static TasQuestTask[] _taskList;
    
    private void Start()
    {
        _currentHp = GameObject.Find("CurrentHp");
        _inputFieldManager = GameObject.Find("TaskNameInputField").GetComponent<InputFieldManager>();
        _dueDate = GameObject.Find("DueDate").GetComponent<TMP_Text>();
        _currentHpChanger = _currentHp.GetComponent<CurrentHealthChanger>();
        _hpTextManager = GameObject.Find("HpText").GetComponent<HpTextManager>();
        _isEditMode = false;
    }

    public static void OnGoalChanged()
    {
        // _taskList = User.GoalData.tasks;
        SetTaskDataDisplay(User.GoalData.tasks[0]);
    }

    /// <summary>
    /// メインカメラの位置にを監視してタスクカードに書き込むべきタスクを_taskListから取り出す。
    /// currentIndexがout of rangeの時には呼ばれないように監視している。
    /// </summary>
    /// <param name="currentIndex"></param>
    public static void OnCurrentTaskChanged(int currentIndex)
    {
        Debug.Log($"set display index {currentIndex}");
        // SetTaskDataDisplay(_taskList[currentIndex]);
        SetTaskDataDisplay(User.GoalData.tasks[currentIndex]);
    }

    public static void OnCurrentHealthChanged(int currentHealthValue)
    {
        User.GoalData.tasks[MainCameraManager.CurrentIndex].currentHealth = currentHealthValue;
        JsonManager.UpdateTaskData(User.GoalData.tasks[MainCameraManager.CurrentIndex]);
    }

    public static void OnMaxHealthChanged(int maxHealthValue)
    {
        User.GoalData.tasks[MainCameraManager.CurrentIndex].maxHealth = maxHealthValue;
        JsonManager.UpdateTaskData(User.GoalData.tasks[MainCameraManager.CurrentIndex]);

    }

    public static void OnTaskNameChanged(string nameValue)
    {
        User.GoalData.tasks[MainCameraManager.CurrentIndex].name = nameValue;
        JsonManager.UpdateTaskData(User.GoalData.tasks[MainCameraManager.CurrentIndex]);

    }
    
    
    private static void SetTaskDataDisplay(TasQuestTask task)
    {
        _inputFieldManager.UpdateTaskName(task.name);
        
        var currentHealth = task.currentHealth;
        var maxHealth = task.maxHealth;
        
        _currentHpChanger.OnHealthChanged(currentHealth, maxHealth);
        
        _hpTextManager.OnHealthChanged(currentHealth, maxHealth);
        
        string dueDateText = task.dueDate;
        dueDateText = "Due:\n" + dueDateText;
        _dueDate.text = dueDateText;
    }

    /// <summary>
    /// モードを変更する関数です。
    /// 現在のモードではないモードになります。
    /// </summary>
    public void ChangeMode()
    {
        _isEditMode = !_isEditMode;
        Debug.Log($"isEditMode: {_isEditMode}");
    }

    /// <summary>
    /// モードに従ってピンチ操作がなされた際に、currentHpかmaxHpを変動させます。
    /// </summary>
    public void PinchControl(float pinchDistance)
    {
        if (_isEditMode)
        {
            //maxHpを変化させる
            _currentHpChanger.PinchMaxHealth(pinchDistance * 10);
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
        get { return _isEditMode; }
        set { _isEditMode = value; }
    }
}
