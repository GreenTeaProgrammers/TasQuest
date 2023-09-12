using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ViewManager : MonoBehaviour
{
    public static async System.Threading.Tasks.Task OnGoalChanged()
    {
        //this is test
        User.SetUserID("MiHOSIRaviWm2eGfbN1GYDhv3sA3");
        User.TasksSnapshot = await User.fireStoreManager.ReadTasks();

        await Road.OnGoalChanged();
        TaskcardManager.OnGoalChanged();
        GameObject.Find("Main Camera").transform.position = new Vector3(
            Road.stagePositions[0].x,
            0.6f,
            Road.stagePositions[0].z); 
    }

    public static async System.Threading.Tasks.Task OnTaskDataChanged()
    {
        User.TasksSnapshot = await User.fireStoreManager.ReadTasks();
        TaskcardManager.OnGoalChanged();
        //メインカメラはcurrentIndexに従った位置に置くようにFix予定
        GameObject.Find("Main Camera").transform.position = new Vector3(
            Road.stagePositions[0].x,
            0.6f,
            Road.stagePositions[0].z); 
    }
}
