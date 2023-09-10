using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class InputFieldManager : MonoBehaviour
{
    //this object
    private TMP_InputField _inputField;
    
    // Start is called before the first frame update
    void Start()
    {
        _inputField = this.GetComponent<TMP_InputField>();
    }
    
    // Update is called once per frame
    void Update()
    {
        _inputField.interactable = TaskcardManager.IsEditMode;
    }

    void UpdateTaskName()
    {
        //Firestoreへ書き込み
    }
}
