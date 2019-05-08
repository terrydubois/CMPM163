using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrCycleColor : MonoBehaviour
{
    Renderer render;
    public float colorR;
    public float colorG;
    public float colorB;

    public void sliderChangedR(float newVal)
    {
        colorR = newVal;
    }
    public void sliderChangedG(float newVal)
    {
        colorG = newVal;
    }
    public void sliderChangedB(float newVal)
    {
        colorB = newVal;
    }

    void Start()
    {
        render = GetComponent<Renderer>();
        render.material.shader = Shader.Find("Custom/Outline");
        colorR = 1;
        colorG = 1;
        colorB = 1;
    }

    void Update()
    {
        Vector4 newColor = new Vector4(colorR, colorG, colorB, 1);
        render.material.SetVector("_OutlineColor", newColor);
    }
}
