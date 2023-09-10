using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class HpTextManager : MonoBehaviour
{
    //this object
    private TMP_Text _myText;
    
    //GameObjects
    private GameObject _currentHp;
    
    //Scripts
    private RectTransform _currentHpTransform;
    
    // Start is called before the first frame update
    void Start()
    {
        _myText = this.GetComponent<TMP_Text>();
        _currentHp = GameObject.Find("CurrentHp");
        _currentHpTransform = _currentHp.GetComponent<RectTransform>();
    }

    /// <summary>
    /// HpTextの内容を書き換える関数です
    /// </summary>
    /// <param name="currentHealth"></param>
    /// <param name="maxHealth"></param>
    public void UpdateHpText(float currentHealth, float maxHealth)
    {
        _myText.text = $"{currentHealth}/{maxHealth}";
    }
    
}
