using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrWaterSliders : MonoBehaviour
{
    Renderer renderWater;
    public GameObject waterPlane;

    public float foamAmount;
    public float waterOriginalY;
    public float waterPlusY;
    public float depthMaxDist;

    public void sliderChangedFoamAmount(float newVal)
    {
        foamAmount = newVal;
    }

    public void sliderChangedWaterPlusY(float newVal)
    {
        waterPlusY = newVal;
    }

    public void sliderChangedDepthMaxDist(float newVal)
    {
        depthMaxDist = newVal;
    }

    void Start()
    {
        // get water shader
        renderWater = waterPlane.GetComponent<Renderer>();
        renderWater.material.shader = Shader.Find("Custom/ShadWater");

        // default values
        foamAmount = 0.75f;
        waterPlusY = 9.0f;
        depthMaxDist = 7.5f;
    }

    void Update()
    {
        // change these values for water shader as the player moves the slider
        renderWater.material.SetFloat("_SurfaceNoiseCutoff", foamAmount);
        waterPlane.transform.position = new Vector3(waterPlane.transform.position.x,
                                                    waterOriginalY + waterPlusY,
                                                    waterPlane.transform.position.z);
        renderWater.material.SetFloat("_DepthMaxDistance", depthMaxDist);
    }
}
