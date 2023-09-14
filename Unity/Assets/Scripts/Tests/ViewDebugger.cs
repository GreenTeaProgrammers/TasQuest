using UnityEngine;

public class ViewDebugger : MonoBehaviour
{
    void Start()
    {
        DataExchanger dataExchanger = GameObject.Find("DataExchanger").GetComponent<DataExchanger>();
        AppData appData = JsonManager.LoadJson();
        User.UserData = appData;
        dataExchanger.ReceiveStatusID("1");
        dataExchanger.ReceiveGoalID("1");

        // Debug.Log(JsonUtility.ToJson(User.UserData));
    }

}
