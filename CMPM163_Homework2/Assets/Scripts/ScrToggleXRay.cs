using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrToggleXRay : MonoBehaviour
{
    public bool xRayEnabled = false;
    public GameObject xRayPlane;

    private float plusY;
    private float plusYDest;
    public float originalY;

    public void toggleXRay()
    {
        xRayEnabled = !xRayEnabled;
    }

    void Start()
    {
        xRayEnabled = true;
    }

    void Update()
    {
        if (xRayEnabled) {
            plusYDest = 0;
        }
        else {
            plusYDest = -originalY;
        }

        if (plusY < plusYDest) {
            plusY += 1.0f;
        }
        else if (plusY > plusYDest) {
            plusY -= 1.0f;
        }

        xRayPlane.transform.position = new Vector3(xRayPlane.transform.position.x,
                                        originalY + plusY,
                                        xRayPlane.transform.position.z);
    }
}
