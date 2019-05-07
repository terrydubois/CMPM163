using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrMoveCam : MonoBehaviour
{

    public float moveSpeed;

    void Start()
    {
        
    }

    void Update()
    {

        transform.position = new Vector3(transform.position.x,
                                        transform.position.y, 
                                        transform.position.z + moveSpeed);
    }
}
