/*
Following tutorial: https://www.youtube.com/watch?v=dycHQFEz8VI
*/

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrGenerateTerrain : MonoBehaviour
{

    public int heightScale = 10;
    public float detailScale = 20.0f;

    void Start()
    {
        Mesh mesh = this.GetComponent<MeshFilter>().mesh;
        Vector3[] verts = mesh.vertices;
        for (int i = 0; i < verts.Length; i++) {
            verts[i].y = Mathf.PerlinNoise((verts[i].x + this.transform.position.x) / detailScale,
                                            (verts[i].z + this.transform.position.z) / detailScale) * heightScale;

        }

        mesh.vertices = verts;
        mesh.RecalculateBounds();
        mesh.RecalculateNormals();
        this.gameObject.AddComponent<MeshCollider>();
    }
}