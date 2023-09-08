using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using Firebase.Firestore;
using UnityEngine;
using FirebaseFirestore = Firebase.Firestore.FirebaseFirestore;

public class FireStoreManager
{
    private readonly string _currentUserID;
    private FirebaseFirestore _dataBase;
    
    //引数はテスト用ユーザーになっています。
    //本番で変更してください
    public FireStoreManager(string userID="RCGhBVMyFfaUIx7fwrcEL5miTnW2")
    {
        _currentUserID = userID;
        _dataBase = FirebaseFirestore.DefaultInstance;
    }

    /// <summary>
    /// QuerySnapshotのusageです。
    /// 参考にするために残してあります
    /// 最終的には消してください。
    /// </summary>
    private async void TasksTest()
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
    
    /// <summary>
    /// FireBaseからタスクを取り出す関数です。
    /// 返り値として QuerySnapshot型のインスタンスsnapshotが返ってきます。
    /// snapshot.Documentsにリストとしてそれぞれのタスクが入っているので加工して使ってください。
    /// 引数としてcurrentUser, currentStatus, currentGoalが必要です。これらの値はswift側から渡される予定です。
    /// </summary>
    /// <returns>QuerySnapshot snapshot</returns>
    public async Task<QuerySnapshot> ReadTasks(string currentStatus="1", string currentGoal="h8eWfbP3NR5tz81maI9p")
    {
        
        Query query = _dataBase.Collection("Users")
            .Document(_currentUserID)
            .Collection("Statuses")
            .Document(currentStatus)
            .Collection("Goals")
            .Document(currentGoal)
            .Collection("TasQuestTasks");
        var tasksSnapshot = await query.GetSnapshotAsync();
        
        return tasksSnapshot;
    }

    /// <summary>
    /// FireStore上に新たなタスクを作成する関数です。
    /// 引数にはStatus, Goal, 新規作成するTaskのID, Taskの内容が必要です
    /// </summary>
    /// <param name="currentStatus">FireStore上の</param>
    /// <param name="currentGoal"></param>
    /// <param name="targetTask"></param>
    /// <param name="taskContext"></param>
    public async void CreateTask(string currentStatus, string currentGoal, string targetTask, Dictionary<string, object> taskContext)
    {
        DocumentReference targetTaskDocument = _dataBase.Collection("Users")
            .Document(_currentUserID)
            .Collection("Statuses")
            .Document(currentStatus)
            .Collection("Goals")
            .Document(currentGoal)
            .Collection("TasQuestTasks")
            .Document(targetTask);

        await targetTaskDocument.SetAsync(taskContext);
    }
    
    /// <summary>
    /// FireStore上に既に存在するタスクを上書きする関数です。
    /// 引数にはStatus, Goal, 新規作成するTaskのID, Taskの内容が必要です
    /// </summary>
    /// <param name="currentStatus"></param>
    /// <param name="currentGoal"></param>
    /// <param name="targetTask"></param>
    /// <param name="taskContext"></param>
    public async void UpdateTask(string currentStatus, string currentGoal, string targetTask, Dictionary<string, object> taskContext)
    { 
        DocumentReference targetTaskDocument = _dataBase.Collection("Users")
            .Document(_currentUserID)
            .Collection("Statuses")
            .Document(currentStatus)
            .Collection("Goals")
            .Document(currentGoal)
            .Collection("TasQuestTasks")
            .Document(targetTask);

        await targetTaskDocument.UpdateAsync(taskContext);
    }
}

