using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
public class ScrNoise : MonoBehaviour
{
    public enum NoiseType {
    ClassicPerlin,
    PeriodicPerlin,
    Simplex,
    SimplexNumericalGrad,
    SimplexAnalyticalGrad
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


    void Update()
    {
        if (_material == null)
        {
            _material = new Material(shader);
            _material.hideFlags = HideFlags.DontSave;
            GetComponent<Renderer>().material = _material;
        }

        _material.shaderKeywords = null;
        _material.EnableKeyword("CNOISE");

        if (_is3D)
            _material.EnableKeyword("THREED");

        if (_isFractal)
            _material.EnableKeyword("FRACTAL");
    }
}
