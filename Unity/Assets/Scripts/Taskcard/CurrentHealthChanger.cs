using UnityEngine;

public class CurrentHealthChanger : MonoBehaviour
{
    //Firestore
    private string _taskID;
    
    //this Object
    private Vector3 _baseScale;
    private RectTransform _myRectTransform;
    
    //DamageDiff
    private GameObject _damageDiff;
    private DamageDiffManager _damageDiffManager;
    
    //HpText
    private GameObject _hpText;
    private HpTextManager _hpTextManager;
    
    //global variables
    private float _currentHealth;
    private float _maxHealth;
    
    void Start()
    {
        _myRectTransform = this.GetComponent<RectTransform>();
        _baseScale = _myRectTransform.localScale;
        
        _damageDiff = GameObject.Find("DamageDiff");
        _damageDiffManager = _damageDiff.GetComponent<DamageDiffManager>();

        _hpText = GameObject.Find("HpText");
        _hpTextManager = _hpText.GetComponent<HpTextManager>();
        
        _damageDiffManager.SetScale(_baseScale);
    }

    public void OnHealthChanged(float currentHealth, float maxHealth)
    {
        _currentHealth = currentHealth;
        _maxHealth = maxHealth;
        
        _myRectTransform.localScale = new Vector3(_currentHealth / _maxHealth, 1.0f, 1.0f);
        _baseScale = _myRectTransform.localScale;
        _damageDiffManager.SetScale(_baseScale);
    }
    
    /// <summary>
    /// ピンチイン、アウトでcurrentHpのスケールを変化させる関数です。
    /// </summary>
    /// <param name="pinchDistance"></param>
    public void PinchCurrentHealth(float pinchDistance)
    {
        _damageDiffManager.SetScale(_baseScale);
        Vector3 newScale = new Vector3(_baseScale.x + pinchDistance,
            _baseScale.y,
            _baseScale.z);

        //scaleを0.0 ~ 1.0に丸める
        newScale.x = Mathf.Clamp(newScale.x, 0.0f, 1.0f);
        
        //HpTextを更新
        _currentHealth = Mathf.Floor(_maxHealth * newScale.x);
        _hpTextManager.OnHealthChanged(_currentHealth, _maxHealth);
        
        _myRectTransform.localScale = newScale;
    }

    /// <summary>
    /// ピンチイン、アウトでmaxHealthを変化させる関数です。
    /// </summary>
    /// <param name="pinchDistance"></param>
    public void PinchMaxHealth(float pinchDistance)
    {
        _maxHealth += Mathf.Floor(pinchDistance * 10);
        _maxHealth = Mathf.Clamp(_maxHealth, _currentHealth, 3000);
        _maxHealth = Mathf.Clamp(_maxHealth, 100, 3000);
        
        
        Vector3 newScale = new Vector3(_currentHealth / _maxHealth,
            1.0f,
            1.0f);
        
        _hpTextManager.OnHealthChanged(_currentHealth, _maxHealth);
        Debug.Log($"maxHealth: {_maxHealth}");
        _myRectTransform.localScale = newScale;
    }

    /// <summary>
    /// ピンチイン、アウトが完了した際にスケールの基準値を再設定する関数です。
    /// </summary>
    public void UpdateMyScale()
    {
        float scaleDiff = _baseScale.x - _myRectTransform.localScale.x;
        Debug.Log($"ScaleDiff {scaleDiff}");
        _baseScale = _myRectTransform.localScale;
        _damageDiffManager.StartTransition(_baseScale);

        if (TaskcardManager.IsEditMode)
        {
            UpdateMaxHealth();
        }
        else
        {
            UpdateCurrentHealth();
            
            EnemyManager enemyManager = Road.enemyHandle[MainCameraManager.CurrentIndex+1].Result.GetComponent<EnemyManager>();
            //currentHpが減るんだったら
            if (scaleDiff >= 0)
            {
                if (scaleDiff != 0)
                {
                    enemyManager.slash();
                }
                
                if (_currentHealth <= 0)
                {
                    enemyManager.Die = true;    
                }
                else if(scaleDiff != 0)
                {
                    enemyManager.Hit = true;
                }
            }
            else
            {
                if (enemyManager.Die == true)
                {
                    enemyManager.Die = false;
                }
            }
        }
    }

    private void UpdateCurrentHealth()
    {
        TaskcardManager.OnCurrentHealthChanged((int)_currentHealth);
    }

    private void UpdateMaxHealth()
    {
        TaskcardManager.OnMaxHealthChanged((int) _maxHealth);
    }
    
}
