using System.Threading.Tasks;
using Firebase.Firestore;
using UnityEngine;

public class SwiftDataExchanger : MonoBehaviour
{
    public void OnUserChangedBySwift(string userID)
    {
        User.SetUserID(userID);
    }
    
    public static async System.Threading.Tasks.Task OnCurrentGoalChangedBySwift(string currentStatus, string currentGoal)
    {
        User.CurrentStatus = currentStatus;
        User.CurrentGoal = currentGoal;
        await ViewManager.OnGoalChanged();
    }

    public static async Task<QuerySnapshot> OnTaskDataChangedBySwift()
    {
        QuerySnapshot tasksSnapshot = await User.fireStoreManager.ReadTasks();
        return tasksSnapshot;
    }
}
