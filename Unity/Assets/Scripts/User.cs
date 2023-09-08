//User should always be only one
public class User
{
    private static string id;
    public static FireStoreManager fireStoreManager;
    
    public static void ChangeUser(string userID)
    {
        id = userID;
        fireStoreManager = new FireStoreManager(id);
    }

    public static string GetUserID()
    {
        return id;
    }
}
