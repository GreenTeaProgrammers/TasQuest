using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMovement : MonoBehaviour
{
    [SerializeField] private float radius = 5.0f;
    float _initialAngle;
    private float _currentDist = 0.0f;
    
    // Start is called before the first frame update
    void Start()
    {
        _initialAngle = this.transform.eulerAngles.y;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void MoveCamera(float dist)
    {
        Transform myTransform = this.transform;
        dist += _currentDist;
        float angle = dist / Mathf.PI * 180;
            
        Vector3 circleMove = new Vector3(radius*Mathf.Sin(dist), myTransform.position.y, radius*Mathf.Cos(dist));
        Vector3 newAngle = new Vector3(0.0f, _initialAngle + angle, 0.0f);
        
        myTransform.position = circleMove;
        myTransform.eulerAngles = newAngle;
    }

    public void UpdateCurrentDist(float dist)
    {
        _currentDist += dist;
    }


}
