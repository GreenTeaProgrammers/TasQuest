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
    private DocumentReference _userDocument;
    
    //引数はテスト用ユーザーになっています。
    //本番で変更してください
    public FireStoreManager(string userID="RCGhBVMyFfaUIx7fwrcEL5miTnW2")
    {
        _currentUserID = userID;
        _dataBase = FirebaseFirestore.DefaultInstance;
        _userDocument = _dataBase.Collection("Users")
                                .Document(_currentUserID);
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
    /// User classのメンバであるid, currentStatus, currentGoalが参照されます。これらの値はswift側から渡される予定です。
    /// </summary>
    /// <returns>QuerySnapshot snapshot</returns>
    public async Task<QuerySnapshot> ReadTasks()
    {
        Query query =
            _userDocument
            .Collection("Statuses")
            .Document(User.CurrentStatus)
            .Collection("Goals")
            .Document(User.CurrentGoal)
            .Collection("TasQuestTasks");
        var tasksSnapshot = await query.GetSnapshotAsync();
        
        return tasksSnapshot;
    }

    /// <summary>
    /// FireStore上に新たなタスクを作成する関数です。
    /// 引数には新規作成するTaskのID, Taskの内容が必要です。
    /// GoalとStatusはUser classのメンバの値が参照されます。
    /// </summary>
    /// <param name="currentStatus">FireStore上の</param>
    /// <param name="currentGoal"></param>
    /// <param name="targetTask"></param>
    /// <param name="taskContext"></param>
    public async void CreateTask(string targetTask, Dictionary<string, object> taskContext)
    {
        DocumentReference targetTaskDocument = 
            _userDocument
            .Collection("Statuses")
            .Document(User.CurrentStatus)
            .Collection("Goals")
            .Document(User.CurrentGoal)
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
    public async void UpdateTask(string targetTask, Dictionary<string, object> taskContext)
    { 
        DocumentReference targetTaskDocument = 
            _userDocument
            .Collection("Statuses")
            .Document(User.CurrentStatus)
            .Collection("Goals")
            .Document(User.CurrentGoal)
            .Collection("TasQuestTasks")
            .Document(targetTask);

        await targetTaskDocument.UpdateAsync(taskContext);
    }
}

