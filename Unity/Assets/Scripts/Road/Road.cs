using System;
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
    
    private static void SetStagesNumberAndRadius(int arg)
    {
        stagesNumber = arg;
        radius = arg * 0.3f;GameObject.Find("Road").transform.localScale = new Vector3((radius/10)+0.08f, 0.00001f, (radius/10f)+0.08f);
        GameObject.Find("cover").transform.localScale = new Vector3((radius/10f)-0.07f, 0.0001f, (radius/10f)-0.07f);
        MainCameraManager._radius = radius;
        accessoryRadius = arg * 0.9f;
        Array.Resize(ref stagePositions, arg);
        Array.Resize(ref id, arg);
        Array.Resize(ref enemyHandle, arg);
        Array.Resize(ref accessoryHandle, arg);
    }

    private static void UpdateStages()
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

    private static void ClearHandle()
    {
        Debug.Log("clear start");
        for (int i = 0; i < stagesNumber; i++)
        {
            Addressables.ReleaseInstance(enemyHandle[i]);
            Addressables.ReleaseInstance(accessoryHandle[i]);
        }
        Debug.Log("clear end");
    }
    
    private static async System.Threading.Tasks.Task RelocateTasks()
    {
        ClearHandle();
        //本来はSwiftから先に呼ばれている

        var goalData = User.GoalData;
        SetStagesNumberAndRadius(goalData.tasks.Length + 2);
        UpdateStages();
        int idx = 0;
        //GenerateStart
        await Generate(idx, "start", -1);
        idx++;
        
        foreach (var task in goalData.tasks)
        {
            await Generate
            (
                idx,
                task.id,
                System.Convert.ToSingle(task.maxHealth)
            );
            idx++;
        }
        await Generate(idx, "goal", -1);
    }
    
    public static async System.Threading.Tasks.Task OnGoalChanged()
    {
        await RelocateTasks();
    }

    static async System.Threading.Tasks.Task OnTaskDataChangedBySwift()
    {
        await RelocateTasks();
    }

    static float GetRadian(int idx)
    {
        float sin = stagePositions[idx].x / radius;
        float cos = stagePositions[idx].z / radius;
        float radian = MathF.Acos(cos); // 0 - PI
        if (sin < -0.001) radian = MathF.PI + (MathF.PI - radian);
        return radian;
    }

    static string GetEnemyOrGoalAddress(float maxHealth, string ID)
    {
        if (ID == "goal")
        {
            return "Goal";
        }
        else if (ID == "start")
        {
            return "Start";
        }
        if (maxHealth < 500)
        {
            return "EnemyWeak";
        }
        if (maxHealth < 1000)
        {
            return "EnemyNormal";
        }
        return "EnemyStrong";
    }

    static void RotateEnemyOrGoal(int idx)
    {
        float deg = GetRadian(idx) * 180 / MathF.PI;
        float rotationDeg = deg + 90;
        Quaternion rot = Quaternion.AngleAxis(rotationDeg, Vector3.up);
        enemyHandle[idx].Result.transform.rotation *= rot;
    }
    
    static string GetRandomAccessoryAddress()
    {
        string address = "";
        Random engine = new Random();
        int accessoryType = engine.Next(0, ACCESSORY_TYPE_NUMBER);
        address = "0" + accessoryType.ToString();
        return address;
    }

    static async System.Threading.Tasks.Task InstantiateEnemyOrGoalFromPrefab(int idx, string address)
    {
        enemyHandle[idx] = Addressables.InstantiateAsync
        (
            address,
            Vector3.zero,
            Quaternion.identity
        );
        await enemyHandle[idx].Task;
        GameObject enemy = enemyHandle[idx].Result;
        enemy.transform.position = stagePositions[idx];
        if (address != "Goal" && address != "Start")
        {
            enemy.GetComponent<EnemyManager>().Index = idx-1;
        }
        
        Debug.Log($"generated{address}");
        
        float sin = stagePositions[idx].x / radius;
        float cos = stagePositions[idx].z / radius;
        float radian = MathF.Acos(cos); // 0 - PI
        if (sin < -0.001) radian = MathF.PI + (MathF.PI - radian);
        float deg = radian * 180 / MathF.PI;
        enemyHandle[idx].Result.transform.position = stagePositions[idx];
    }
    
    static async System.Threading.Tasks.Task InstantiateAccessoryFromPrefab(int idx, string address)
    {
        accessoryHandle[idx] = Addressables.InstantiateAsync
        (
            address,
            Vector3.zero,
            Quaternion.identity
        );
        await accessoryHandle[idx].Task;
        float accessoryRadian = GetRadian(idx) + 2 * MathF.PI / stagesNumber / 4; // パラメータ職人の余地
        accessoryHandle[idx].Result.transform.position = new Vector3
        (
            accessoryRadius * MathF.Sin(accessoryRadian),
            0,
            accessoryRadius * MathF.Cos(accessoryRadian)
        );
    }


    static async System.Threading.Tasks.Task GenerateEnemyOrGoal(int idx, string argId, float maxHealth)
    {
        id[idx] = argId;
        string address = GetEnemyOrGoalAddress(maxHealth, argId);
        await InstantiateEnemyOrGoalFromPrefab(idx, address);
        RotateEnemyOrGoal(idx);
    }
    
    static async System.Threading.Tasks.Task GenerateAccessories(int idx)
    {
        string address = GetRandomAccessoryAddress();
        await InstantiateAccessoryFromPrefab(idx, address);
        
        Debug.Log("generated accessory");
    }
    
    static async System.Threading.Tasks.Task Generate(int idx, string argId, float maxHealth)
    {
        await GenerateEnemyOrGoal(idx, argId, maxHealth);
        await GenerateAccessories(idx);
    }
}