using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEditor.UI;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using Object = System.Object;

public class Road : MonoBehaviour
{
    public static float radius;
    public static int stagesNumber;
    public static Vector3[] stagePositions;
    public static string[] id;
    public static AsyncOperationHandle<GameObject>[] handle;

    private const float INITIAL_RADIAN = 0;

    Task[] GetTasksFromJson()
    {
        JsonManager jm = new JsonManager();
        // FireBase ができ次第 0 番固定ではなくなります
        Goal[] goals = jm.LoadJson().statuses[0].goals;
        return goals[0].tasks;
    }

    void SetStagesNumberAndRadius(int arg)
    {
        stagesNumber = arg;
        radius = arg;
        Array.Resize(ref stagePositions, arg);
        Array.Resize(ref id, arg);
        Array.Resize(ref handle, arg);
    }

    void UpdateStages()
    {
        stagePositions[0] = new Vector3
        (
            radius * MathF.Sin(INITIAL_RADIAN),
            0,
            radius * MathF.Cos(INITIAL_RADIAN)
        );
        float radianDelta = 2 * MathF.PI / stagesNumber;
        float currentRadian = INITIAL_RADIAN;
        for (int i = 1; i < stagesNumber; i++)
        {
            currentRadian += radianDelta;
            stagePositions[i] = new Vector3
            (
                radius * MathF.Sin(currentRadian),
                0,
                radius * MathF.Cos(currentRadian)
            );
        }
    }

    void Clear()
    {
        Debug.Log("clear start");
        for (int i = 0; i < stagesNumber; i++)
        {
            Addressables.ReleaseInstance(handle[i]);
        }
        Debug.Log("clear end");
    }
    async System.Threading.Tasks.Task RelocateTasks()
    {
        Clear();
        //本来はSwiftから先に呼ばれている
        User.SetUserID("RCGhBVMyFfaUIx7fwrcEL5miTnW2");
        var querySnapshot = await User.fireStoreManager.ReadTasks();
        foreach (var i in querySnapshot.Documents)
        {
            var dict = i.ToDictionary();
        }
        SetStagesNumberAndRadius(querySnapshot.Documents.Count() + 1);
        UpdateStages();
        int idx = 0;
        foreach (var i in querySnapshot.Documents)
        {
            var dict = i.ToDictionary();
            await GenerateEnemyOrGoal(idx, i.Id, System.Convert.ToSingle(dict["maxHealth"]));
            idx++;
        }
        await GenerateEnemyOrGoal(idx, "goal", -1);
    }
    
    void OnGoalChanged()
    {
        RelocateTasks();
    }

    void OnTaskDataChangedBySwift()
    {
        RelocateTasks();
    }

    async System.Threading.Tasks.Task GenerateEnemyOrGoal(int idx, string id, float maxHealth)
    {
        string address;
        if (maxHealth < 0)
        {
            address = "Goal";
        }
        else if (maxHealth < 500)
        {
            address = "EnemyWeak";
        }
        else if (maxHealth < 1000)
        {
            address = "EnemyNormal";
        }
        else
        {
            address = "EnemyStrong";
        }
        handle[idx] = Addressables.InstantiateAsync
        (
            address,
            Vector3.zero,
            Quaternion.identity
        );
        await handle[idx].Task;
        GameObject enemy = handle[idx].Result;
        enemy.transform.position = stagePositions[idx];
        
        Debug.Log("generated");
        
        float sin = stagePositions[idx].x / radius;
        float cos = stagePositions[idx].z / radius;
        float radian = MathF.Acos(cos); // 0 - PI
        if (sin < -0.001) radian = MathF.PI + (MathF.PI - radian);
        float deg = radian * 180 / MathF.PI;

        //Debug.Log(maxHealth);
        //Debug.Log(radian * 180 / MathF.PI);
        
        Quaternion rot = Quaternion.AngleAxis(90 + deg, Vector3.up);
        enemy.transform.rotation *= rot;
    }

    async void Start()
    {
        await RelocateTasks();
        Clear(); // test
    }
}
