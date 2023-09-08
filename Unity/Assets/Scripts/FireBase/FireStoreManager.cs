using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using Firebase.Firestore;
using UnityEngine;
using FirebaseFirestore = Firebase.Firestore.FirebaseFirestore;

public class FireStoreManager : MonoBehaviour
{
    public async void Awake()
    {
        // var res = await ReadFireStore("", "", "", "");
        // foreach (var i in res.Keys)
        // {
        //     Debug.Log($"{i} : {res[i]}");
        // }
        
        tasks();
    }

    public async void tasks()
    {
        QuerySnapshot tasksSnapshot = await ReadTasks();
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
    
    public async Task<QuerySnapshot> ReadTasks()
    {
        FirebaseFirestore dataBase = FirebaseFirestore.DefaultInstance;
        Query query = dataBase.Collection("Users")
            .Document("RCGhBVMyFfaUIx7fwrcEL5miTnW2")
            .Collection("Statuses")
            .Document("1")
            .Collection("Goals")
            .Document("h8eWfbP3NR5tz81maI9p")
            .Collection("TasQuestTasks");
        var snapshot = await query.GetSnapshotAsync();
        return snapshot;
    }
    
    public async Task<Dictionary<string, object>> ReadFireStore(string usersDocument, string statusDocument, string goalDocument, string taskDocument)
    {
        FirebaseFirestore dataBase = FirebaseFirestore.DefaultInstance;
        DocumentReference docref = dataBase.Collection("Users")
            .Document("RCGhBVMyFfaUIx7fwrcEL5miTnW2")
            .Collection("Statuses")
            .Document("1")
            .Collection("Goals")
            .Document("h8eWfbP3NR5tz81maI9p");
        
        var snapshot = await docref.GetSnapshotAsync();
        Dictionary<string, object> result = snapshot.ToDictionary();
        
        return result;
    }
}
