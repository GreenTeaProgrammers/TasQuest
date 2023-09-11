using System.Threading.Tasks;
using Firebase.Firestore;
using UnityEngine;

public class SwiftDataExchanger : MonoBehaviour
{
    public void OnUserChangedBySwift(string userID)
    {
        User.SetUserID(userID);
    }
    
    public async System.Threading.Tasks.Task OnCurrentGoalChangedBySwift(string currentStatus, string currentGoal)
    {
        User.CurrentStatus = currentStatus;
        User.CurrentGoal = currentGoal;
        User.TasksSnapshot = await User.fireStoreManager.ReadTasks();
        await ViewManager.OnGoalChanged();
        // return tasksSnapshot;
    }

    public async Task<QuerySnapshot> OnTaskDataChangedBySwift()
    {
        QuerySnapshot tasksSnapshot = await User.fireStoreManager.ReadTasks();
        return tasksSnapshot;
    }
}
