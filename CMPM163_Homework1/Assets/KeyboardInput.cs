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
        // if player is pressing UP or DOWN, change playerInput variable accordingly
        if (Input.GetKey(KeyCode.UpArrow)) {
            playerInput += 0.3f;
        }
        else if (Input.GetKey(KeyCode.DownArrow)) {
            playerInput -= 0.3f;
        }

        // keep playerInput between 0 and 60
        playerInput = Mathf.Clamp(playerInput, 0, 60);

        // send playerInput to our blur material to change the steps of blur
        render.material.SetFloat("_Steps", playerInput);
        Debug.Log(playerInput);
    }
}
