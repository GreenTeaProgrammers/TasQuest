using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ViewDebugger : MonoBehaviour
{
    // Start is called before the first frame update
    async void Start()
    {
        User.SetUserID("MiHOSIRaviWm2eGfbN1GYDhv3sA3");
        await SwiftDataExchanger.OnCurrentGoalChangedBySwift("1", "BD33ZOlTGJUVYLShEgQ4");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
