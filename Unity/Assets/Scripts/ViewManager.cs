using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ViewManager : MonoBehaviour
{
    public static async System.Threading.Tasks.Task OnGoalChanged()
    {
        //this is test
        User.SetUserID("RCGhBVMyFfaUIx7fwrcEL5miTnW2");
        User.TasksSnapshot = await User.fireStoreManager.ReadTasks();

        await Road.OnGoalChanged();
        TaskcardManager.OnGoalChanged();
        GameObject.Find("MainCamera").transform.position = Road.stagePositions[0];
    }

    public static async System.Threading.Tasks.Task OnTaskDataChanged()
    {
        
    }
}
