//User should always be only one

using Firebase.Firestore;
using UnityEngine;

public static class User
{
    private static string id;
    public static FireStoreManager fireStoreManager;
    //テスト用の値です。
    private static string currentStatus = "1";
    private static string currentGoal = "BD33ZOlTGJUVYLShEgQ4";
    private static QuerySnapshot tasksSnapshot;
    
    public static void SetUserID(string userID)
    {
        id = userID;
        fireStoreManager = new FireStoreManager(id);
    }

    public static string GetUserID()
    {
        return id;
    }

    public static string CurrentStatus
    {
        get { return currentStatus; }
        set { currentStatus = value; }
    }

    public static string CurrentGoal
    {
        get { return currentGoal; }
        set { currentGoal = value; }
    }
    
    public static QuerySnapshot TasksSnapshot
    {
        get { return tasksSnapshot; }
        set { tasksSnapshot = value; }
    }
}
