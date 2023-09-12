using TMPro;
using UnityEngine;

public class InputFieldManager : MonoBehaviour
{
    //this component
    private static TMP_InputField _inputField;
    
    //
    private static string _prevName = "";
    private static string _name = "";
    
    void Start()
    {
        _inputField = this.GetComponent<TMP_InputField>();
    }
    
    void Update()
    {
        _inputField.interactable = TaskcardManager.IsEditMode;
    }

    public void UpdateName(string taskName)
    {
        _name = taskName;
        _inputField.text = _name;
    }
    
    public static async System.Threading.Tasks.Task UpdateTaskName()
    {
        Debug.Log("InputFieldからFirestoreに書き込み");
        await TaskcardManager.OnTaskDataChanged("name", _inputField.text);
        //Firestoreへ書き込み
    }

    private void OnEndEdit()
    {
        _name = _inputField.text;
    }
}
