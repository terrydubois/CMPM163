using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
public class ScrNoise : MonoBehaviour
{
    public enum NoiseType {
    ClassicPerlin
    }

    [SerializeField]
    NoiseType _noiseType;

    [SerializeField]
    bool _is3D;

    [SerializeField]
    bool _isFractal;

    [SerializeField]
    Shader shader;

    Material _material;

    public float noiseO = 0.0f;
    public float noiseS = 1.0f;
    public float noiseW = 0.5f;

    void Update()
    {
        // set noise (clouds) variables
        if (_material == null)
        {
            _material = new Material(shader);
            _material.hideFlags = HideFlags.DontSave;
            GetComponent<Renderer>().material = _material;
        }

        _material.shaderKeywords = null;
        _material.EnableKeyword("CNOISE");

        if (_is3D) {
            _material.EnableKeyword("THREED");
        }

        if (_isFractal) {
            _material.EnableKeyword("FRACTAL");
        }

        // set player-adjustable variables for clouds
        _material.SetFloat("_NoiseO", noiseO);
        _material.SetFloat("_NoiseS", noiseS);
        _material.SetFloat("_NoiseW", noiseW);
    }

}
