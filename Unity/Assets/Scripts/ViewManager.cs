using System;
using UnityEngine;

public class ViewManager : MonoBehaviour
{
    public static bool goalChangeFlag = false;
    
    public static async System.Threading.Tasks.Task OnGoalChanged()
    {
        await Road.OnGoalChanged();
        TaskcardManager.OnGoalChanged();
        GameObject.Find("Main Camera").transform.position = new Vector3(
            Road.stagePositions[0].x,
            0.6f,
            Road.stagePositions[0].z); 
    }

    public static void OnTaskDataChanged()
    {
        TaskcardManager.OnGoalChanged();
        //メインカメラはcurrentIndexに従った位置に置くようにFix予定
        GameObject.Find("Main Camera").transform.position = new Vector3(
            Road.stagePositions[0].x,
            0.6f,
            Road.stagePositions[0].z); 
    }

    private async void Update()
    {
        if (goalChangeFlag)
        {
            goalChangeFlag = false;
            await OnGoalChanged();
        }
    }
}
