using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMovement : MonoBehaviour
{
    [SerializeField]private float _radius = 7.0f;
    [SerializeField]float _initialAngle;
    [SerializeField] private float _snapSenctivity;
    
    private float _currentDist = 0.0f;
    private float _snapHold = 0.0f;
    private int _snapStreak = 0;
    
    // Start is called before the first frame update
    void Start()
    {
        _initialAngle = this.transform.eulerAngles.y;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    //もうちょっとちゃんとしたスナップにするにはSwipe関数の方でpinchDistanceを変える必要あり。
    private float Snap(float dist)
    {
        int stagesNumber = Road.stagesNumber;
        float unit = 2 * Mathf.PI / stagesNumber;
        int currentIndex = (int) Mathf.Floor(dist / unit);
        
        if (dist % unit > unit - _snapSenctivity)
        {
            dist = unit * (currentIndex+1) - _snapSenctivity;
        }
        // else if (dist % unit < _snapSenctivity)
        // {
        //     dist = unit * currentIndex - _snapSenctivity;
        //     Debug.Log("Snap 2");
        // }

        return dist;
    }
    
    public void MoveCamera(float dist)
    {
        Transform myTransform = this.transform;
        dist += _currentDist;
        dist = Snap(dist);
        float angle = dist / Mathf.PI * 180;
            
        Vector3 circleMove = new Vector3(_radius*Mathf.Sin(dist), myTransform.position.y, _radius*Mathf.Cos(dist));
        Vector3 newAngle = new Vector3(0.0f, _initialAngle + angle, 0.0f);
        
        myTransform.position = circleMove;
        myTransform.eulerAngles = newAngle;
    }

    public void SetCurrentDist(float dist)
    {
        _currentDist += dist;
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
