using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateMoveObj : MonoBehaviour
{
    public bool rotate;
    public float rotateSpeed = 10f;
    public bool moveX;
    public bool moveY;
    public bool moveZ;
    public float moveSpeed = 0.1f;

    void Start()
    {
        InvokeRepeating("flipMoveSpeed", 2.0f, 2.0f);
    }

    void Update()
    {
        if (rotate) {
            transform.Rotate(Vector3.up, rotateSpeed * Time.deltaTime);
        }

        float moveSpeedX = 0;
        float moveSpeedY = 0;
        float moveSpeedZ = 0;
        if (moveX) {
            moveSpeedX = moveSpeed;
        }
        if (moveY) {
            moveSpeedY = moveSpeed;
        }
        if (moveZ) {
            moveSpeedZ = moveSpeed;
        }

        if (moveX || moveY || moveZ) {
            transform.position = new Vector3(
                transform.position.x + moveSpeedX,
                transform.position.y + moveSpeedY,
                transform.position.z + moveSpeedZ
                );
        }
    }

    void flipMoveSpeed()
    {
        moveSpeed *= -1;
    }
}