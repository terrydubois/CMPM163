// following tutorial: https://www.youtube.com/watch?v=OJkGGuudm38

Shader "Custom/ShadXRayReplace"
{
    Properties
    {
        _EdgeColor("XRay Edge Color", Color) = (0, 0, 0, 1) // color of x-ray outline
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry-1"
            "RenderType" = "Opaque"
            "XRay" = "ColoredOutline"
        }
        LOD 200 // level of detail

        CGPROGRAM
        #pragma surface surf Lambert // built-in Unity lighting

        sampler2D _MainTex; // need to input texture, does not matter what texture is
        

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o) // need framework for surface shader
        {
        }
        
        ENDCG
    }
    Fallback "Diffuse"
}