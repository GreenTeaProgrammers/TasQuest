using TMPro;
using UnityEngine;

public class EnemyManager : MonoBehaviour
{
    private bool _isActive;
    private float _radius;
    private int _index = -1;
    public int Index
    {
        get { return _index;}
        set { _index = value; }
    }

    private bool _hit;
    public bool Hit
    {
        get { return _hit;}
        set{
            if (value == true)
            {
                Debug.Log("Hit");
                if (_enemyWeak.activeInHierarchy)
                {
                    _weakAnimator.SetTrigger("Hit");
                }
                else if (_enemyNormal.activeInHierarchy)
                {
                    _normalAnimator.SetTrigger("Hit");
                }
                else if(_enemyStrong.activeInHierarchy)
                {
                    _strongAnimator.SetTrigger("Hit");
                }
            }
            
        }
    }
    
    private GameObject _mainCamera;
    private TMP_Text _hpText;
    private GameObject _enemyWeak;
    private GameObject _enemyNormal;
    private GameObject _enemyStrong;
    private ParticleSystem _smokeParticle;
    private Animator _weakAnimator;
    private Animator _normalAnimator;
    private Animator _strongAnimator;
    private ParticleSystem _slash;
    
    void Start()
    {
        _mainCamera = GameObject.Find("Main Camera");
        _hpText = GameObject.Find("HpText").GetComponent<TMP_Text>();
        _enemyWeak = this.transform.GetChild(1).gameObject;
        _enemyNormal = this.transform.GetChild(2).gameObject;
        _enemyStrong = this.transform.GetChild(3).gameObject;
        _smokeParticle = this.transform.GetChild(4).gameObject.GetComponent<ParticleSystem>();
        _weakAnimator = _enemyWeak.GetComponent<Animator>();
        _normalAnimator = _enemyNormal.GetComponent<Animator>();
        _strongAnimator = _enemyStrong.GetComponent<Animator>();
        _slash = this.transform.GetChild(5).gameObject.GetComponent<ParticleSystem>();
        _hit = false;
    }

    public void slash()
    {
        _slash.Play();
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

        //_indexとカメラのcurrentIndexが等しいときアクティブ
        _isActive = Index == MainCameraManager.CurrentIndex;
        if (_isActive)
        {
            int maxHp = int.Parse(_hpText.text.Split("/")[1]);
            if (maxHp < 500)
            {
                ChangeEnemyStrength("weak");
            }
            else if(maxHp < 1000)
            {
                ChangeEnemyStrength("normal");
            }
            else
            {
                ChangeEnemyStrength("strong");
            }
        }
    }

    private void ChangeEnemyStrength(string strength)
    {
        if (strength == "weak" && !_enemyWeak.activeInHierarchy)
        {
            _smokeParticle.Play();
            _enemyWeak.SetActive(true);
            _enemyNormal.SetActive(false);
            _enemyStrong.SetActive(false);
        }
        else if (strength == "normal" && !_enemyNormal.activeInHierarchy)
        {
            _smokeParticle.Play();
            _enemyWeak.SetActive(false);
            _enemyNormal.SetActive(true);
            _enemyStrong.SetActive(false);
        }
        else if(strength == "strong" && !_enemyStrong.activeInHierarchy)
        {
            _smokeParticle.Play();
            _enemyWeak.SetActive(false);
            _enemyNormal.SetActive(false);
            _enemyStrong.SetActive(true);
        }
    }
    
}
