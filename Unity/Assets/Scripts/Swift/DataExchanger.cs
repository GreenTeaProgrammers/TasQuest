using TMPro;
using UnityEngine;

public class DataExchanger : MonoBehaviour
{
    public void ReceiveAppData(string jsonString)
    {
        AppData jsonData = JsonManager.String2Json(jsonString);
        User.UserData = jsonData;
        JsonManager.SaveJson(jsonData);
        
        //below this line are all test
        // TMP_Text output = GameObject.Find("Output").GetComponent<TMP_Text>();
        // output.text = jsonString;
    }

    public void ReceiveStatusID(string currentStatusId)
    {
        foreach (var status in User.UserData.statuses)
        {
            if (status.id == currentStatusId)
            {
                User.StatusData = status;
            }
        }
    }

    public void ReceiveGoalID(string currentGoalId)
    {
        foreach (var goal in User.StatusData.goals)
        {
                if (goal.id == currentGoalId)
                {
                    User.GoalData = goal;
                }
        }

        //asyncにできないのでフラグをオンにして ViewManager.OnGoalChanged()を読んでいる
        ViewManager.goalChangeFlag = true;

        //below this line are all test
        // TMP_Text output = GameObject.Find("Output").GetComponent<TMP_Text>();
        // output.text = currentGoalId;
    }

    public static void SendAppData()
    {
        Debug.Log("SendAppData to IOS Native!!!");
    }
}
