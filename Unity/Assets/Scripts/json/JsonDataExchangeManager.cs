using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JsonDataExchangeManager : MonoBehaviour
{
    public void ReceiveJsonData(string jsonString)
    {
        string receivedJson = jsonString;
        JsonManager jsonManager = new JsonManager();
        AppData jsonData = jsonManager.String2Json(jsonString);
        jsonManager.SaveJson(jsonData);
    }
}
