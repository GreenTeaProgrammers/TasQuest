using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SubsystemsImplementation;

public class TouchManager : MonoBehaviour
{
    [SerializeField] private GameObject mainCamera;
    [SerializeField] private float minScrollDist = 1.5f;
    
    private Vector2 startPos = new Vector2(0, 0);
    private Vector2 endPos = new Vector2(0, 0);
    private CameraMovement _cameraMovement;
    
    // Start is called before the first frame update
    void Start()
    {
        _cameraMovement = mainCamera.GetComponent<CameraMovement>();
    }

    // Update is called once per frame
    void Update()
    {
        TouchManagement();
    }
    private void TouchManagement()
    {
        
        if (Application.isEditor)
        {
            if (Input.GetMouseButtonDown(0))
            {
                startPos = Input.mousePosition;
                Debug.Log("MouseDown");
            }
            
            if (Input.GetMouseButton(0) && Input.GetMouseButtonDown(0) == false)
            {
                Swipe(startPos, Input.mousePosition);
            }

            if (Input.GetMouseButtonUp(0))
            {
                endPos = Input.mousePosition;
                UpdateMainCameraTransform((Input.mousePosition.y - startPos.y) * 0.001f);
                Debug.Log("MouseUp");
            }
        }
        else
        {
            //touchCountはタッチしている指の本数を持つ。1本目が0
            if (Input.touchCount > 0)
            {
                Touch touch = Input.GetTouch(0);

                if (touch.phase == TouchPhase.Began)
                {
                    startPos = touch.position;
                    Debug.Log("TouchDown");
                }

                if (touch.phase == TouchPhase.Moved)
                {
                    Swipe(startPos, touch.position);
                    Debug.Log("OnTouch");
                }

                if (touch.phase == TouchPhase.Ended)
                {
                    endPos = touch.position;
                    UpdateMainCameraTransform((touch.position.y - startPos.y) * 0.001f);
                    Debug.Log("TouchUp");
                }
            }
        }
    }

    private void Swipe(Vector2 startPosition, Vector2 currentPosition)
    {
        float xDiff = (currentPosition.x - startPosition.x) * 0.001f;
        float yDiff = (currentPosition.y - startPosition.y) * 0.001f;
        Debug.Log(currentPosition.y + " - " + startPosition.y + " = " + yDiff);
        if (Mathf.Abs(yDiff) > minScrollDist)
        {
            MoveMainCamera(-yDiff);
            
            if (yDiff > 0)
            {
                Debug.Log("ScrollUp!");
            }
            else
            {
                Debug.Log("ScrollDown!");
            }
        }
    }

    private void MoveMainCamera(float yDiff)
    {
        _cameraMovement.MoveCamera(yDiff);
    }

    private void UpdateMainCameraTransform(float yDiff)
    { 
        _cameraMovement.SetCurrentDist(-yDiff);
    }
}
