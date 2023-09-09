using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class DebugHandler : MonoBehaviour
{
    TMP_InputField _inputField;

    void Start()
    {
        _inputField = GameObject.Find("TaskNameInputField").GetComponent<TMP_InputField>();
    }

    void Update()
    {

    }

    public void InputName()
    {
        string name = _inputField.text;
        Debug.Log(name);
    }
}
