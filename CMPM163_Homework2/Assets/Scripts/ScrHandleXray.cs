using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ScrHandleXray : MonoBehaviour
{
    public Shader xRayShader;

    public void OnEnable()
    {
        GetComponent<Camera>().SetReplacementShader(xRayShader, "XRay");
    }

    void Start()
    {
        
    }

    void Update()
    {
        
    }
}
