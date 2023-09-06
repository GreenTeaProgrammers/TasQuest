using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.SubsystemsImplementation;

public class TouchHandller : MonoBehaviour
{
    [SerializeField] private bool isTouchDebug;
    [SerializeField] private GameObject mainCamera;
    [SerializeField] private float minScrollDist = 1.5f;
    
    //シングルタッチ用の変数
    private Vector2 _startPos = new Vector2(0, 0);
    private Vector2 _endPos = new Vector2(0, 0);
    
    //ダブルタッチ用の変数
    private float _previousPinchDistance = 0.0f;
    
    
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
    
    //タッチ操作を管理するメソッドです。
    //マウス用とタッチ用の2種類を if(!isTouchDebug)でわけています。
    //上から3種のif文は
    //  1.タッチが開始されたとき
    //  2.タッチが継続しているとき
    //  3.タッチが終了したとき
    //中身が実行されます。直接処理を書かず、タッチ操作事態に関するメソッドを生やしていってください。
    private void TouchManagement()
    {
        
        if (!isTouchDebug)
        {
            if (Input.GetMouseButtonDown(0))
            {
                _startPos = Input.mousePosition;
                Debug.Log("MouseDown");
            }
            
            if (Input.GetMouseButton(0) && Input.GetMouseButtonDown(0) == false)
            {
                Swipe(_startPos, Input.mousePosition);
            }

            if (Input.GetMouseButtonUp(0))
            {
                _endPos = Input.mousePosition;
                UpdateMainCameraTransform((Input.mousePosition.y - _startPos.y) * 0.001f);
                Debug.Log("MouseUp");
            }
        }
        else
        {
            //2本以上の指でタップしたとき
            if (Input.touchCount >= 2)
            {
                Touch touch1 = Input.GetTouch(0);
                Touch touch2 = Input.GetTouch(1);

                if (touch2.phase == TouchPhase.Began)
                {
                    _previousPinchDistance = 
                        Vector2.Distance(touch1.position, touch2.position);
                }
                else if (touch1.phase == TouchPhase.Moved && touch2.phase == TouchPhase.Moved)
                {
                    float currentPinchDistance = 
                        Vector2.Distance(touch1.position, touch2.position);
                    float pinchDistance = currentPinchDistance - _previousPinchDistance;
                    
                    Debug.Log(pinchDistance);
                    Pinch(pinchDistance);
                }
            }
            else if (Input.touchCount > 0)
            {
                Touch touch = Input.GetTouch(0);

                if (touch.phase == TouchPhase.Began)
                {
                    _startPos = touch.position;
                    Debug.Log("TouchDown" + touch.position);
                }

                if (touch.phase == TouchPhase.Moved)
                {
                    Swipe(_startPos, touch.position);
                    Debug.Log("OnTouch" + touch.position);
                }

                if (touch.phase == TouchPhase.Ended)
                {
                    _endPos = touch.position;
                    UpdateMainCameraTransform((touch.position.y - _startPos.y) * 0.001f);
                    Debug.Log("TouchUp" + touch.position);
                }
            }

        }
    }

    //スワイプに操作をしたときに呼ばれる
    //yDiff, xDiffを引数に関数をここから呼び出してください
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

    //ピンチ操作をしたときに呼ばれる関数です
    //pinchDistanceを引数にここから関数を呼び出してください
    //pinchDistanceは
    //      ピンチインしたときには負の値とピンチの距離
    //      ピンチアウトしたときには生の値とピンチの距離
    //が格納されていま
    private void Pinch(float pinchDistance)
    {
        
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
