using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrSpin : MonoBehaviour
{

    public float spinSpeed = 10f;

    void Start()
    {
        
    }

    void Update()
    {
        transform.Rotate(0, 0,  Time.deltaTime * spinSpeed, Space.Self);
    }
}
