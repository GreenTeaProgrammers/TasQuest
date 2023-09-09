using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor.UI;
using UnityEngine;


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
        Vector3[] newStagePositions = new Vector3[1];
        newStagePositions[0] = new Vector3
        (
            radius * MathF.Cos(INITIAL_RADIAN),
            0,
            radius * MathF.Sin(INITIAL_RADIAN)
        );
        float radianDelta = 2 * MathF.PI / stagesNumber;
        float currentRadian = INITIAL_RADIAN;
        for (int i = 1; i < stagesNumber; i++)
        {
            currentRadian += radianDelta;
            newStagePositions[i] = new Vector3
            (
                radius * MathF.Cos(currentRadian),
                0,
                radius * MathF.Sin(currentRadian)
            );
        }
        stagePositions = newStagePositions;
    }

    void OnGoalChanges() {
        Task[] tasks = GetTasksFromJson();
        stagesNumber = tasks.Length + 1;
        SetRadius(100); // てきとう
        UpdateStages();
    }
}
