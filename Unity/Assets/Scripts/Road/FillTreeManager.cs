using UnityEngine;
using Random = System.Random;

public class FillTreeManager : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        int id = new System.Random().Next(0, 3);
        if (id == 0)
        {
            this.transform.GetChild(0).gameObject.SetActive(true);
        }
        else if (id == 1)
        {
            this.transform.GetChild(1).gameObject.SetActive(true);
        }
        else
        {
            this.transform.GetChild(2).gameObject.SetActive(true);
        }
    }
}
