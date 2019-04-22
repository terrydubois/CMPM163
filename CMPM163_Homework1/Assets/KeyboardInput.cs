using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KeyboardInput : MonoBehaviour
{
    Renderer render;
    float playerInput = 10.0f;

    // Start is called before the first frame update
    void Start()
    {
        render = GetComponent<Renderer>();

        render.material.shader = Shader.Find("Custom/Blur");
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.UpArrow)) {
            playerInput += 0.3f;
        }
        else if (Input.GetKey(KeyCode.DownArrow)) {
            playerInput -= 0.3f;
        }
        playerInput = Mathf.Clamp(playerInput, 0, 60);

        render.material.SetFloat("_Steps", playerInput);
        Debug.Log(playerInput);
    }
}
