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
    
    public void ReceiveGoalID(string currentGoalId)
    {
        //below this line are all test
        // TMP_Text output = GameObject.Find("Output").GetComponent<TMP_Text>();
        // output.text = currentGoalId;
    }

    // public static async Task<Goal> OnTaskDataChangedBySwift()
    // {
    //     
    // }
}
