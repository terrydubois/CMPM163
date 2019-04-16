using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateMoveObj : MonoBehaviour
{
    public bool rotate;
    public float rotateSpeed = 10f;
    public bool move;
    public float moveSpeed = 10f;

    void Start()
    {
        InvokeRepeating("flipMoveSpeed", 2.0f, 2.0f);
    }

    void Update()
    {
        if (rotate) {
            transform.Rotate(Vector3.up, rotateSpeed * Time.deltaTime);
        }

        if (move) {
            transform.position = new Vector3(
                transform.position.x + moveSpeed,
                transform.position.y,
                transform.position.z
                );
        }
    }

    void flipMoveSpeed()
    {
        moveSpeed *= -1;
    }
}