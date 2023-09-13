using System;
using Unity.VisualScripting;
using UnityEngine;

public class EnemyManager : MonoBehaviour
{
    private bool _isActive;
    
    private GameObject _mainCamera;
    private float _radius;
    private int _index;
    public int Index
    {
        get { return _index;}
        set { _index = value; }
    }
    
    void Start()
    {
        _mainCamera = GameObject.Find("Main Camera");
    }
    
    void Update()
    {
        //メインカメラの方向を向かせる
        Vector3 targetTransform = _mainCamera.transform.position;
        this.transform.LookAt(
            new Vector3(
                targetTransform.x, 
                this.transform.position.y, 
                targetTransform.z));

        if (Index == CameraMovement.CurrentIndex)
        {
            _isActive = true;
        }
        else
        {
            _isActive = false;
        }
    }
    
}
