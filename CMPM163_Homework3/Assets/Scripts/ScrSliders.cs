using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrSliders : MonoBehaviour
{
    public GameObject cloudsObj;
    public float noiseO;
    public float noiseS;
    public float noiseW;

    // get new values if player has adjusted sliders
    public void sliderChangedOAmount(float newVal)
    {
        noiseO = newVal;
    }
    public void sliderChangedSAmount(float newVal)
    {
        noiseS = newVal;
    }
    public void sliderChangedWAmount(float newVal)
    {
        noiseW = newVal;
    }

    void Start()
    {
        noiseO = 0.0f;
        noiseS = 1.0f;
        noiseW = 0.5f;
    }

    // update clouds variables based on sliders
    void Update()
    {
        cloudsObj.GetComponent<ScrNoise>().noiseO = noiseO;
        cloudsObj.GetComponent<ScrNoise>().noiseS = noiseS;
        cloudsObj.GetComponent<ScrNoise>().noiseW = noiseW;
    }
}
