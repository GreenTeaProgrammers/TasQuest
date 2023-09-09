using System;
using Unity.VisualScripting;
using UnityEngine;

public class DamageDiffManager : MonoBehaviour
{
    private RectTransform _myRectTransform;
    private Vector3 _baseScale;
    
    private float _transitionRate = 0.0f;
    private Vector3 _transitionDiff;
    public bool isOnTransition = false;
    
    void Update()
    {
        if (isOnTransition)
        {
            Transition2CurrentHp();
        }
    }
    
    void Start()
    {
        _myRectTransform = this.GetComponent<RectTransform>();
    }

    /// <summary>
    /// DamageDiffのスケールをcurrentHpのスケールと統一するための関数です。
    /// </summary>
    /// <param name="currentHpScale"></param>
    public void UnifyScaleWithCurrentHp(Vector3 currentHpScale)
    {
        _myRectTransform.localScale = currentHpScale;
        _baseScale = currentHpScale;
    }

    /// <summary>
    /// DamageDiffをcurrentHpのスケールまで変化させ始めます。
    /// DamageDiffとcurrentHpのスケールの差分を計算したのちにトランジション中かどうかのフラグをオンにします。
    /// 差分を計算するためにcurrentHealthHpのスケール情報が引数として必要です。
    /// currentHPが増える場合にはトランジションではなく瞬時にスケールが書き換わります。
    /// </summary>
    /// <param name="currentHealthScale"></param>
    public void StartTransition(Vector3 currentHealthScale)
    {
        isOnTransition = false;
        _transitionRate = 0.0f;
        _baseScale = _myRectTransform.localScale;
        _transitionDiff = currentHealthScale - _baseScale;
        Debug.Log($"transitionDiff = {_transitionDiff}");
        
        //currentHpが増える場合はトランジションしない
        if (_transitionDiff.x > 0.0f)
        {
            UnifyScaleWithCurrentHp(currentHealthScale);
        }
        else
        {
            isOnTransition = true;
        }
    }
    
    /// <summary>
    /// DamageDiffのスケールを実際にcurrentHPのスケールまでトランジションさせます。
    /// Update関数内でisOnTransitionフラグがオンの時に呼び出されます。
    /// </summary>
    private void Transition2CurrentHp()
    {
        float transitionTime = 1.0f;
        
        _transitionRate += Time.deltaTime;
        Vector3 newScale = _baseScale + 
                           _transitionDiff * Easing.QuadOut(_transitionRate, transitionTime, 0.0f, 1.0f);
        
        //scaleを0.0 ~ 1.0に丸める
        newScale.x = Mathf.Clamp(newScale.x, 0.0f, 1.0f);
        
        _myRectTransform.localScale = newScale;
        
        if (_transitionRate >= transitionTime)
        {
            isOnTransition = false;
            _transitionRate = 0.0f;
        }
    }
    
}
