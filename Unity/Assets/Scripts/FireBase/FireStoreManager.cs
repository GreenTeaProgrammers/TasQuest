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
        var res = await ReadFireStore();
        foreach (var i in res.Keys)
        {
            Debug.Log($"{i} : {res[i]}");
        }
    }

    public async Task<Dictionary<string, object>> ReadFireStore()
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
