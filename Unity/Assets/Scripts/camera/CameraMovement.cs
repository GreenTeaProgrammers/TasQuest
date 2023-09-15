using System;
using UnityEngine;

public class MainCameraManager : MonoBehaviour
{
    public static float _radius = 7.0f;
    [SerializeField]float _initialAngle;
    
    private float _currentDist = 0.0f;
    private float _previousDist = 0.0f;
    
    private static int currentIndex = 0;
    public static int CurrentIndex
    {
        get { return currentIndex;}
        set
        {
            currentIndex = value;
            if (currentIndex < Road.stagesNumber - 2)
            {
                TaskcardManager.OnCurrentTaskChanged(currentIndex);
            }
        }
    }

    private void Update()
    {
        Debug.Log($"currentDist : {_currentDist} ,");
    }

    // Start is called before the first frame update
    void Start()
    {
        _initialAngle = this.transform.eulerAngles.y;
    }
    
    public void MoveCamera(float dist)
    {
        Transform myTransform = this.transform;
        dist += _currentDist;
        dist = Mathf.Clamp(dist, 0.0f, 2 * Mathf.PI - 2*Mathf.PI/Road.stagesNumber);
        Debug.Log($"dist : {dist}");
        
        
        CurrentIndex = (int) Mathf.Floor(dist / (2 * Mathf.PI / Road.stagesNumber));
        Debug.Log($"currentIndex: {currentIndex}");
        float angle = dist / Mathf.PI * 180;
            
        _previousDist = dist;
        
        Vector3 circleMove = new Vector3(_radius*Mathf.Sin(dist), myTransform.position.y, _radius*Mathf.Cos(dist));
        Vector3 newAngle = new Vector3(0.0f, _initialAngle + angle, 0.0f);
        
        myTransform.position = circleMove;
        myTransform.eulerAngles = newAngle;
    }

    public void SetCurrentDist(float dist)
    {
        _currentDist += dist;
        _currentDist = Mathf.Clamp(_currentDist, 0.0f, 2 * Mathf.PI);
    }

    public void SetRadius(float radius)
    {
        _radius = radius;
    }

    //モード切替の時呼ばれる
    public void MoveCameraParallel(float dist)
    {
        Transform myTransform = this.transform;
        myTransform.position += -myTransform.right * dist;
    }
}
