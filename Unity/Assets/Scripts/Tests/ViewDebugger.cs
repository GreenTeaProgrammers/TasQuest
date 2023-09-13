using UnityEngine;

public class ViewDebugger : MonoBehaviour
{
    void Start()
    {
        DataExchanger dataExchanger = GameObject.Find("DataExchanger").GetComponent<DataExchanger>();
        AppData appData = JsonManager.LoadJson();
        User.UserData = appData;
        dataExchanger.ReceiveGoalID("1");
        // DataExchanger.("Json should be here");
    }

}
