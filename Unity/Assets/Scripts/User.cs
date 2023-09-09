//User should always be only one
public class User
{
    private static string id;
    public static FireStoreManager fireStoreManager;
    //テスト用の値です。
    private static string currentStatus = "1";
    private static string currentGoal = "h8eWfbP3NR5tz81maI9p";
    
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
}
