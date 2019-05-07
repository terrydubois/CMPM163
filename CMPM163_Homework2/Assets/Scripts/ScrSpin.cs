using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrSpin : MonoBehaviour
{
    public float spinSpeedX = 10f;
    public float spinSpeedY = 10f;
    public float spinSpeedZ = 10f;

    void Start()
    {
        
    }

    void Update()
    {
        transform.Rotate(Time.deltaTime * spinSpeedX,
                        Time.deltaTime * spinSpeedY, 
                        Time.deltaTime * spinSpeedZ,
                        Space.Self);
    }
}
