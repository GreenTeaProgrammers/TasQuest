using TMPro;
using UnityEngine;

public class InputFieldManager : MonoBehaviour
{
    //this component
    private static TMP_InputField _inputField;
    
    //
    private static string _prevName = "";
    private static string _name = "";
    
    private void Start()
    {
        _inputField = this.GetComponent<TMP_InputField>();
    }
    
    private async void Update()
    {
        _inputField.interactable = TaskcardManager.IsEditMode;
        if (_prevName != _name)
        {
            _prevName = _name;
            Debug.Log("InputFieldMangerからFirestoreへ書き込み");
            await TaskcardManager.OnTaskDataChanged("name", _inputField.text);
        }
    }

    public void UpdateTaskName(string taskName)
    {
        _name = taskName;
        _inputField.text = _name;
    }

    public void OnEndEdit()
    {
        _name = _inputField.text;
    }
}
