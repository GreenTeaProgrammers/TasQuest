using UnityEngine;

public class CameraMovement : MonoBehaviour
{
    [SerializeField]public static float _radius = 7.0f;
    [SerializeField]float _initialAngle;
    [SerializeField] private float _snapSensitivity = 0.1f;
    
    private float _currentDist = 0.0f;

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
    
    // Start is called before the first frame update
    void Start()
    {
        _initialAngle = this.transform.eulerAngles.y;
    }
    
    //もうちょっとちゃんとしたスナップにするにはSwipe関数の方でpinchDistanceを変える必要あり。
    private float Snap(float dist)
    {
        int stagesNumber = Road.stagesNumber;
        float unit = 2 * Mathf.PI / stagesNumber;
        CurrentIndex = (int) Mathf.Floor(dist / unit);
        Debug.Log($"currentIndex: {currentIndex}");
        
        if (dist % unit > unit - _snapSensitivity)
        {
            dist = unit * (currentIndex+1) - _snapSensitivity;
        }
        // else if (dist % unit < _snapSensitivity)
        // {
        //     dist = unit * currentIndex - _snapSencitivity;
        //     Debug.Log("Snap 2");
        // }

        return dist;
    }
    
    public void MoveCamera(float dist)
    {
        Transform myTransform = this.transform;
        dist += _currentDist;
        dist = Mathf.Clamp(dist, 0.0f, 2 * Mathf.PI);
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
