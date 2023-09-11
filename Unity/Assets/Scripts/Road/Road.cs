using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEditor.UI;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;

public class Road : MonoBehaviour
{
    public static float radius;
    public static int stagesNumber;
    public static Vector3[] stagePositions;

    private const float INITIAL_RADIAN = 0;
    
    //テスト用変数
    [SerializeField] private float testRadius;

    Task[] GetTasksFromJson()
    {
        JsonManager jm = new JsonManager();
        // FireBase ができ次第 0 番固定ではなくなります
        Goal[] goals = jm.LoadJson().statuses[0].goals;
        return goals[0].tasks;
    }

    void SetRadius(float arg)
    {
        radius = arg;
        testRadius = arg;
    }

    void UpdateStages() 
    {
        Array.Resize(ref stagePositions, stagesNumber);
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

    void OnGoalChanges()
    {
        Task[] tasks = GetTasksFromJson();
        stagesNumber = tasks.Length + 1;
        SetRadius(100); // てきとう
        UpdateStages();
    }

    async void GenerateEnemy(Vector3 tgtPos, float maxHealth)
    {
        String enemyAddress;
        if (maxHealth < 500)
        {
            enemyAddress = "EnemyWeak";
        }
        else if (maxHealth < 1000)
        {
            enemyAddress = "EnemyNormal";
        }
        else
        {
            enemyAddress = "EnemyStrong";
        }
        AsyncOperationHandle<GameObject> handle = Addressables.InstantiateAsync
        (
            enemyAddress,
            Vector3.zero,
            Quaternion.identity
        );
        await handle.Task;
        GameObject enemy = handle.Result;
        enemy.transform.position = tgtPos;
        
        float sin = tgtPos.x / radius;
        float cos = tgtPos.z / radius;
        float radian = MathF.Acos(cos); // 0 - PI
        if (sin < -0.001) radian = MathF.PI + (MathF.PI - radian);
        float deg = radian * 180 / MathF.PI;
        
        Debug.Log(radian * 180 / MathF.PI);
        
        Quaternion rot = Quaternion.AngleAxis(90 + deg, Vector3.up);
        enemy.transform.rotation *= rot;
    }
    
    void Start()
    {
        stagesNumber = 10;
        SetRadius(stagesNumber); // * 1.5 とかも試したけど現状そのまま放り込んでよい感じ
        UpdateStages();
        for (int i = 0; i < stagesNumber; i++)
        {
            GenerateEnemy(stagePositions[i], 100);
        }
    }
}
