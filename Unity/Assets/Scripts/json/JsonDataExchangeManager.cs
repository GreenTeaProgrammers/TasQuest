using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JsonDataExchangeManager : MonoBehaviour
{
    //Swift側からJSONをstringで渡すときに呼び出す関数
    //現状は受け取ったデータを保存するようにしてあるが、今後保存せずに関数に渡すようになるかも
    //仕様が未定なのでいったんコミット
    public void ReceiveJsonData(string jsonString)
    {
        string receivedJson = jsonString;
        JsonManager jsonManager = new JsonManager();
        AppData jsonData = jsonManager.String2Json(jsonString);
        jsonManager.SaveJson(jsonData, "Assets/Resources/SwiftData.json");
    }
}
