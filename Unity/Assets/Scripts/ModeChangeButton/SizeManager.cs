using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SizeManager : MonoBehaviour
{
    int TgtScale;
    /*
        TgtScale :  0 : need downsizing
                    1 : need upsizing
                   -1 : need NO change
    */

    const float ScaleDelta = 0.02f;

    void Start()
    {
        TgtScale = -1;
    }

    void Update()
    {
        if (TgtScale == -1) return;

        Vector3 UpdateScale = this.transform.localScale;
        if (TgtScale == 1)
        {
            UpdateScale[0] += ScaleDelta;
            UpdateScale[1] += ScaleDelta;
            UpdateScale[2] += ScaleDelta;
            if (UpdateScale[0] >= 1)
            {
                TgtScale = -1;
                this.transform.localScale = new Vector3(1f, 1f, 1f);
            }
            else
            {
                this.transform.localScale = UpdateScale;
            }
        }
        else
        {
            UpdateScale[0] -= ScaleDelta;
            UpdateScale[1] -= ScaleDelta;
            UpdateScale[2] -= ScaleDelta;
            if (UpdateScale[0] <= 0)
            {
                TgtScale = -1;
                this.transform.localScale = new Vector3(0f, 0f, 0f);
            }
            else
            {
                this.transform.localScale = UpdateScale;
            }
        }
    }

    public void UpdateTgtScale()
    {
        if (this.transform.localScale.x == 1)
        {
            TgtScale = 0;
        }
        else
        {
            TgtScale = 1;
        }
    }
}
