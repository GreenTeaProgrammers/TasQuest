using UnityEngine;

public class JsonManagerTest : MonoBehaviour
{
    void Start()
    {
        TestJsonLoad();
    }

    //jsonが正しくロードできているか出力して確かめます。
    void TestJsonLoad()
    {
        AppData jsonData = JsonManager.LoadJson();
        Debug.Log("Status");
        Debug.Log("id: " + jsonData.statuses[0].id);
        Debug.Log("name: " + jsonData.statuses[0].name);
        Debug.Log("------------------------------------");
        Goal goal = jsonData.statuses[0].goals[0];
        Debug.Log("Goal");
        Debug.Log("id: " + goal.id);
        Debug.Log("name: " + goal.name);
        Debug.Log("description: " + goal.description);
        Debug.Log("createdAt: " + goal.createdAt); 
        Debug.Log("updatedAt: " + goal.updatedAt); 
        Debug.Log("thumbnail: " + goal.thumbnail);
        Debug.Log("isStarred: " + goal.isStarred);
        Debug.Log("------------------------------------");
        TasQuestTask task = goal.tasks[0];
        Debug.Log("Task");
        Debug.Log("id: " + task.id);
        Debug.Log("name: " + task.name);
        Debug.Log("description: " + task.description);
        Debug.Log("dueDate: " + task.dueDate);
        Debug.Log("maxHealth: " + task.maxHealth);
        Debug.Log("currentHealth: " + task.currentHealth);
        Debug.Log("Tag: " + task.tags[0]);
        Debug.Log("Tags: " + task.tags);
        Debug.Log("isVisible: " + task.isVisible);
        Debug.Log("------------------------------------");
        Debug.Log("Check array is working");
        TasQuestTask task1 = goal.tasks[1];
        Debug.Log("task1 id: " + task1.id);
    }
}
