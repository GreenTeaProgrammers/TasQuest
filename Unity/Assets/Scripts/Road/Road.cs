using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Unity.VisualScripting;
using UnityEditor;
using UnityEditor.UI;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using Random = System.Random;

public class Road : MonoBehaviour
{
    public static float radius;
    public static int stagesNumber;
    public static Vector3[] stagePositions;
    public static string[] id;
    public static AsyncOperationHandle<GameObject>[] enemyHandle;
    public static AsyncOperationHandle<GameObject>[] accessoryHandle;

    private const float INITIAL_RADIAN = 0;
    private static float accessoryRadius;
    private const int ACCESSORY_TYPE_NUMBER = 9;
    
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
        accessoryRadius = arg * 1.2f;
        Array.Resize(ref stagePositions, arg);
        Array.Resize(ref id, arg);
        Array.Resize(ref enemyHandle, arg);
        Array.Resize(ref accessoryHandle, arg);
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

    void ClearHandle()
    {
        Debug.Log("clear start");
        for (int i = 0; i < stagesNumber; i++)
        {
            Addressables.ReleaseInstance(enemyHandle[i]);
            Addressables.ReleaseInstance(accessoryHandle[i]);
        }
        Debug.Log("clear end");
    }
    async System.Threading.Tasks.Task RelocateTasks()
    {
        ClearHandle();
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
        foreach (var taskDoc in querySnapshot.Documents)
        {
            await GenerateEnemyOrGoal
            (
                idx,
                taskDoc.Id,
                System.Convert.ToSingle(taskDoc.ToDictionary()["maxHealth"])
            );
            idx++;
        }
        await GenerateEnemyOrGoal(idx, "goal", -1);
    }
    
    async System.Threading.Tasks.Task OnGoalChanged()
    {
        await RelocateTasks();
    }

    async System.Threading.Tasks.Task OnTaskDataChangedBySwift()
    {
        await RelocateTasks();
    }

    async System.Threading.Tasks.Task GenerateEnemyOrGoal(int idx, string argId, float maxHealth)
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
        enemyHandle[idx] = Addressables.InstantiateAsync
        (
            address,
            Vector3.zero,
            Quaternion.identity
        );
        await enemyHandle[idx].Task;
        GameObject enemy = enemyHandle[idx].Result;
        enemy.transform.position = stagePositions[idx];
        id[idx] = argId;
        
        float sin = stagePositions[idx].x / radius;
        float cos = stagePositions[idx].z / radius;
        float radian = MathF.Acos(cos); // 0 - PI
        if (sin < -0.001) radian = MathF.PI + (MathF.PI - radian);
        float deg = radian * 180 / MathF.PI;

        Debug.Log("generated enemy");
        
        Quaternion rot = Quaternion.AngleAxis(90 + deg, Vector3.up);
        enemy.transform.rotation *= rot;
        
        Random engine = new Random();
        int accessoryType = engine.Next(0, ACCESSORY_TYPE_NUMBER);
        address = "0" + accessoryType.ToString();
        accessoryHandle[idx] = Addressables.InstantiateAsync
        (
            address,
            Vector3.zero,
            Quaternion.identity
        );
        await accessoryHandle[idx].Task;
        GameObject accessory = accessoryHandle[idx].Result;
        float accessoryRadian = radian + 2 * MathF.PI / stagesNumber / 4;
        accessory.transform.position = new Vector3
        (
            accessoryRadius * MathF.Sin(accessoryRadian),
            0,
            accessoryRadius * MathF.Cos(accessoryRadian)
        );
        
        Debug.Log("generated accessory");
    }

    async void Start()
    {
        await RelocateTasks();
        ClearHandle(); // test
    }
}