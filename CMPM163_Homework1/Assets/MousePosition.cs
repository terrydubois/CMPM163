using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MousePosition : MonoBehaviour
{
    Renderer render;

    // Start is called before the first frame update
    void Start()
    {
        render = GetComponent<Renderer>();

        render.material.shader = Shader.Find("Custom/Blur");
    }

    // Update is called once per frame
    void Update()
    {
        render.material.SetFloat("_Steps", Mathf.Clamp(Input.mousePosition.y / 5, 0, 100));


        Debug.Log(Input.mousePosition);
    }
}
