using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using Firebase.Firestore;
using UnityEngine;

public class SwiftDataExchanger : MonoBehaviour
{
    public void OnUserChangedBySwift(string userID)
    {
        User.SetUserID(userID);
    }
    
    public async Task<QuerySnapshot> OnCurrentGoalChangedBySwift(string currentStatus, string currentGoal)
    {
        User.CurrentStatus = currentStatus;
        User.CurrentGoal = currentGoal;
        QuerySnapshot tasksSnapshot = await User.fireStoreManager.ReadTasks();
        return tasksSnapshot;
    }

    public async Task<QuerySnapshot> OnTaskDataChangedBySwift()
    {
        QuerySnapshot tasksSnapshot = await User.fireStoreManager.ReadTasks();
        return tasksSnapshot;
    }
}
