using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PinchTest : MonoBehaviour
{
    public Vector3 _initialScale;
    // Start is called before the first frame update
    void Start()
    {
        _initialScale = this.transform.lossyScale;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void PinchScale(float pinchDistance)
    {
        Vector3 newScale = new Vector3(_initialScale.x + pinchDistance,
            _initialScale.y + pinchDistance, _initialScale.z + pinchDistance);
        this.transform.localScale = newScale;
        Debug.Log("PinchScale: " + newScale);
        Debug.Log("---------------------------------------------");
    }

    public void UpdateInitialScale()
    {
        _initialScale = this.transform.localScale;
    }
}
