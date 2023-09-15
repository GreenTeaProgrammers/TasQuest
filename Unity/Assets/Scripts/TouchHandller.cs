using UnityEngine;

public class TouchHandler : MonoBehaviour
{
    //次の空改行までの変数以外についているSerializedFieldは最終的には外してください。デバッグ用に臨時でつけています
    [SerializeField] private bool isTouchDebug;
    [SerializeField] private GameObject mainCamera;
    [SerializeField] private GameObject currentHealth;
    [SerializeField] private GameObject damageDiff;
    
    //シングルタッチ用の変数
    private Vector2 _startPos = new Vector2(0, 0);
    private Vector2 _endPos = new Vector2(0, 0);
    [SerializeField] private float minScrollDist = 1.5f;
    
    //ダブルタッチ用の変数
    private float _previousPinchDistance;
    [SerializeField] public float scrollSencitivity;
    [SerializeField]public float pinchSencitivity;
    
    //スクリプト
    private MainCameraManager _mainCameraManager;
    private CurrentHealthChanger _currentHealthChanger;
    private DamageDiffManager _damageDiffManager;
    private TaskcardManager _taskcardManager;
    
    // Start is called before the first frame update
    void Start()
    {
        _mainCameraManager = mainCamera.GetComponent<MainCameraManager>();
        _currentHealthChanger = currentHealth.GetComponent<CurrentHealthChanger>();
        _damageDiffManager = damageDiff.GetComponent<DamageDiffManager>();
        _taskcardManager = GameObject.Find("TaskCard").GetComponent<TaskcardManager>();
        
        scrollSencitivity = 0.001f;
        pinchSencitivity = 0.001f;
        _previousPinchDistance = 0.0f;
    }

    // Update is called once per frame
    void Update()
    {
        //DamageDiffが遷移してる間は操作不可能
        if (!_damageDiffManager.isOnTransition)
        {
            TouchManagement();
        }
    }
    
    private void TouchManagement()
    {
        
        if (!isTouchDebug)
        {
            if (Input.GetMouseButtonDown(0))
            {
                _startPos = Input.mousePosition;
            }
            
            if (Input.GetMouseButton(0) && Input.GetMouseButtonDown(0) == false)
            {
                // Swipe(_startPos, Input.mousePosition);
                Vector2 currentPosition = Input.mousePosition;
                // float xDiff = (currentPosition.x - _startPos.x) * scrollSencitivity;
                float yDiff = (currentPosition.y - _startPos.y) * scrollSencitivity;
                if (Mathf.Abs(yDiff) > minScrollDist)
                {
                    Scroll(-yDiff);
                }
            }

            if (Input.GetMouseButtonUp(0))
            {
                _endPos = Input.mousePosition;
                float yDiff = (Input.mousePosition.y - _startPos.y) * scrollSencitivity;
                if (Mathf.Abs(yDiff) > minScrollDist)
                {
                    ScrollEnd(yDiff);
                }
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
                    
                    Pinch(pinchDistance * pinchSencitivity);
                }
                else if (touch2.phase == TouchPhase.Ended || touch1.phase == TouchPhase.Ended)
                {
                    float currentPinchDistance = 
                        Vector2.Distance(touch1.position, touch2.position);
                    float pinchDistance = currentPinchDistance - _previousPinchDistance;
                    
                    PinchEnd(pinchDistance);
                }
            }
            //シングルタッチの時
            else if (Input.touchCount > 0)
            {
                Touch touch = Input.GetTouch(0);

                if (touch.phase == TouchPhase.Began)
                {
                    _startPos = touch.position;
                }

                if (touch.phase == TouchPhase.Moved)
                {
                    Vector2 currentPosition = touch.position;
                    // float xDiff = (currentPosition.x - _startPos.x) * scrollSencitivity;
                    float yDiff = (currentPosition.y - _startPos.y) * scrollSencitivity;
                    if (Mathf.Abs(yDiff) > minScrollDist)
                    {
                        Scroll(-yDiff);
                    }
                    
                    
                }

                if (touch.phase == TouchPhase.Ended)
                {
                    _endPos = touch.position;
                    float yDiff = (touch.position.y - _startPos.y) * scrollSencitivity;
                    if (Mathf.Abs(yDiff) > minScrollDist)
                    {
                        ScrollEnd(yDiff);
                    }
                }
            }

        }
    }

    //スワイプに操作をしたときに呼ばれる
    //yDiff, xDiffを引数に関数をここから呼び出してください
    private void Scroll(float yDiff)
    {
        _mainCameraManager.MoveCamera(yDiff);
        // if (yDiff > 0)
        // {
        //     Debug.Log("ScrollUp!");
        // }
        // else
        // {
        //     Debug.Log("ScrollDown!");
        // }
    
    }

    private void ScrollEnd(float yDiff)
    {
        _mainCameraManager.SetCurrentDist(-yDiff);
    }
    //ピンチ操作をしたときに呼ばれる関数です
    //pinchDistanceを引数にここから関数を呼び出してください
    //pinchDistanceは
    //      ピンチインしたときには負の値とピンチの距離
    //      ピンチアウトしたときには生の値とピンチの距離
    //が格納されていま
    private void Pinch(float pinchDistance)
    {
        // _currentHealthChanger.PinchCurrentHealth(pinchDistance);
        _taskcardManager.PinchControl(pinchDistance);
    }

    private void PinchEnd(float pinchDistance)
    {
        _currentHealthChanger.UpdateMyScale();
    }
}
