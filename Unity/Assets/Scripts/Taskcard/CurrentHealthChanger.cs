using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UIElements;

public class CurrentHealthChanger : MonoBehaviour
{
    private RectTransform _myRectTransform;
    private Vector3 _baseScale;
    private GameObject _damageDiff;
    private DamageDiffManager _damageDiffManager;
    
    void Start()
    {
        _myRectTransform = this.GetComponent<RectTransform>();
        _baseScale = _myRectTransform.localScale;
        _damageDiff = GameObject.Find("DamageDiff");
        _damageDiffManager = _damageDiff.GetComponent<DamageDiffManager>();
        
        _damageDiffManager.UnifyScaleWithCurrentHp(_baseScale);
    }
    
    /// <summary>
    /// ピンチイン、アウトでcurrentHpのスケールを変化させる関数です。
    /// </summary>
    /// <param name="pinchDistance"></param>
    public void PinchScale(float pinchDistance)
    {
        _damageDiffManager.UnifyScaleWithCurrentHp(_baseScale);
        Vector3 newScale = new Vector3(_baseScale.x + pinchDistance,
            _baseScale.y,
            _baseScale.z);

        //scaleを0.0 ~ 1.0に丸める
        newScale.x = Mathf.Clamp(newScale.x, 0.0f, 1.0f);
        
        _myRectTransform.localScale = newScale;
    }

    /// <summary>
    /// ピンチイン、アウトが完了した際にスケールの基準値を再設定する関数です。
    /// </summary>
    public void UpdateMyScale()
    {
        _baseScale = _myRectTransform.localScale;
        Debug.Log($"Update MyScale {_baseScale}");
        _damageDiffManager.StartTransition(_baseScale);
    }
}
