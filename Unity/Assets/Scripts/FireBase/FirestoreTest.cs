using System.Collections;
using System.Collections.Generic;
using Firebase.Firestore;
using UnityEngine;

public class FirestoreTest : MonoBehaviour
{
    // Start is called before the first frame update
    async void Start()
    {
        User.ChangeUser("RCGhBVMyFfaUIx7fwrcEL5miTnW2");
        QuerySnapshot tasksSnapshot = await User.fireStoreManager.ReadTasks();
        foreach (var taskDocument in tasksSnapshot.Documents)
        {
            Dictionary<string, object> task = taskDocument.ToDictionary();

            Debug.Log("-----------------------------------------");
            Debug.Log($"Task ID(key) : {taskDocument.Id}");
            foreach (var j in task.Keys)
            {
                Debug.Log($"{j} : {task[j]}");
            }
            Debug.Log("----------------------------------------");
        }
    }
}
