using UnityEngine;

public class Easing : MonoBehaviour
{
    public static float QuadOut(float t, float totalTime, float min, float max)
    {
        max -= min;
        t /= totalTime;
        return -max * t * (t - 2) + min;
    }
}
