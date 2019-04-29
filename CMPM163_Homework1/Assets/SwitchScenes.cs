using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SwitchScenes : MonoBehaviour
{

    void Start()
    {
        
    }

    void Update()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        string sceneName = currentScene.name;

        if (Input.GetKeyUp(KeyCode.Space)) {
            if (sceneName == "Part A") {
                SceneManager.LoadScene("Part B");
            }
            else if (sceneName == "Part B") {
                SceneManager.LoadScene("Part C");
            }
            else if (sceneName == "Part C") {
                SceneManager.LoadScene("Part A");
            }
        }
    }
}
