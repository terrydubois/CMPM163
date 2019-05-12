using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ScrSwitchScenes : MonoBehaviour
{

    public void switchScenes()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        string sceneName = currentScene.name;

        if (sceneName == "PartA") {
            SceneManager.LoadScene("PartB");
        }
        else {
            SceneManager.LoadScene("PartA");
        }
    }
}
