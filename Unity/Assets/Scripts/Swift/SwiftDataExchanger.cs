using System.Threading.Tasks;
using UnityEngine;

public class DataExchanger : MonoBehaviour
{
    public static void ReceiveAppData(string jsonString)
    {
        AppData jsonData = JsonManager.String2Json(jsonString);
        User.UserData = jsonData;
        JsonManager.SaveJson(jsonData);
    }
    
    public static void ReceiveGoalID(string currentGoalId)
    {
        Goal currentGoal;
        
    }
    
    
    // public static async Task<Goal> OnTaskDataChangedBySwift()
    // {
    //     
    // }
}
