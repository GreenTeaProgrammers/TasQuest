using System;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;

public class EnemyManager : MonoBehaviour
{
    private bool _isActive;
    private float _radius;
    private int _index;
    public int Index
    {
        get { return _index;}
        set { _index = value; }
    }
    
    private GameObject _mainCamera;
    private TMP_Text _hpText;
    private GameObject _enemyWeak;
    private GameObject _enemyNormal;
    private GameObject _enemyStrong;
    
    void Start()
    {
        _mainCamera = GameObject.Find("Main Camera");
        _hpText = GameObject.Find("HpText").GetComponent<TMP_Text>();
        _enemyWeak = this.transform.GetChild(1).gameObject;
        _enemyNormal = this.transform.GetChild(2).gameObject;
        _enemyStrong = this.transform.GetChild(3).gameObject;
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
        _isActive = Index == CameraMovement.CurrentIndex;
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
        if (strength == "weak")
        {
            _enemyWeak.SetActive(true);
            _enemyNormal.SetActive(false);
            _enemyStrong.SetActive(false);
        }
        else if (strength == "normal")
        {
            _enemyWeak.SetActive(false);
            _enemyNormal.SetActive(true);
            _enemyStrong.SetActive(false);
        }
        else
        {
            _enemyWeak.SetActive(false);
            _enemyNormal.SetActive(false);
            _enemyStrong.SetActive(true);
        }
    }
    
}
