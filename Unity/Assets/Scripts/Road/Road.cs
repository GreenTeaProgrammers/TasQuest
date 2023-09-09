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

    private const float INITIAL_RADIAN = 0;

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

    async void Start() // 本来は OnGoalChanges()
    {
        //本来はSwiftから先に呼ばれている
        User.SetUserID("RCGhBVMyFfaUIx7fwrcEL5miTnW2");
        var querySnapshot = await User.fireStoreManager.ReadTasks();
        int idx = 0;
        foreach (var i in querySnapshot.Documents)
        {
            var dict = i.ToDictionary();
            idx++;
        }
        stagesNumber = idx + 1;
        SetRadius(stagesNumber);
        UpdateStages();
        idx = 0;
        foreach (var i in querySnapshot.Documents)
        {
            var dict = i.ToDictionary();
            GenerateEnemyOrGoal(stagePositions[idx], System.Convert.ToSingle(dict["maxHealth"]));
            idx++;
        }
        GenerateEnemyOrGoal(stagePositions[stagesNumber - 1], -1);
    }

    async void GenerateEnemyOrGoal(Vector3 tgtPos, float maxHealth)
    {
        String address;
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
        AsyncOperationHandle<GameObject> handle = Addressables.InstantiateAsync
        (
            address,
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

        Debug.Log(maxHealth);
        Debug.Log(radian * 180 / MathF.PI);
        
        Quaternion rot = Quaternion.AngleAxis(90 + deg, Vector3.up);
        enemy.transform.rotation *= rot;
    }
}
