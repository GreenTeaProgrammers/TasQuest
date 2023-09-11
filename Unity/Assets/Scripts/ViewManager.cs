using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ViewManager : MonoBehaviour
{
    // Start is called before the first frame update
    public static async void OnGoalChanged()
    {
        //this is test
        User.SetUserID("RCGhBVMyFfaUIx7fwrcEL5miTnW2");
        User.TasksSnapshot = await User.fireStoreManager.ReadTasks();

        await Road.OnGoalChanged();
        // await TaskcardManager.
    
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
