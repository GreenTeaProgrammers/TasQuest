using TMPro;
using UnityEngine;

public class HpTextManager : MonoBehaviour
{
    //this object
    private TMP_Text _myText;
    
    //global variables
    private float _currentHealth;
    private float _maxHealth;
    
    void Start()
    {
        _myText = this.GetComponent<TMP_Text>();
    }

    /// <summary>
    /// HpTextの内容を書き換える関数です
    /// </summary>
    /// <param name="currentHealth"></param>
    /// <param name="maxHealth"></param>
    public void OnHealthChanged(float currentHealth, float maxHealth)
    {
        _currentHealth = currentHealth;
        _maxHealth = maxHealth;
        _myText.text = $"{_currentHealth}/{_maxHealth}";
    }

    public void PinchMaxHealth(float pinchDistance)
    {
        
    }
    
}
