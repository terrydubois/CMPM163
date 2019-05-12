using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrCycleColor : MonoBehaviour
{
    Renderer renderOutline;
    Renderer renderGround;
    public GameObject groundPlane;

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
        // get outline shader and ground shader
        renderOutline = GetComponent<Renderer>();
        renderOutline.material.shader = Shader.Find("Custom/ShadOutlineAndPhong");
        renderGround = groundPlane.GetComponent<Renderer>();
        renderGround.material.shader = Shader.Find("Custom/ShadTronGround");

        // default values
        colorR = 0;
        colorG = 1;
        colorB = 1;
    }

    void Update()
    {
        // change these values for outline shader and ground shader as the player moves the sliders
        Vector4 newColor = new Vector4(colorR, colorG, colorB, 1);
        renderOutline.material.SetVector("_OutlineColor", newColor);
        renderGround.material.SetVector("_Color", newColor);
    }
}
