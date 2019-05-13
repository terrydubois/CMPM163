// following tutorial: https://www.youtube.com/watch?v=OJkGGuudm38

Shader "Custom/OutlineXRay"
{
    Properties
    {
        _EdgeColor("Edge Color", Color) = (1, 1, 1, 1) // color of x-ray outline
    }

    SubShader
    {
        Stencil
        {
            Ref 0 // value passed to screen buffer
            Comp NotEqual // tell engne to compare if reference value and current value are not equal
        }

        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "XRay" = "ColoredOutline"
        }

        ZWrite Off // do not write these pixels to depth buffer
        ZTest Always // always be depth testing
        Blend One One // allows for additive blending

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 viewDir : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f output;
                output.vertex = UnityObjectToClipPos(v.vertex);
                output.uv = v.uv;
                output.normal = UnityObjectToWorldNormal(v.normal);
                output.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz); // get angle we are viewing mesh at
                return output;
            }

            float4 _EdgeColor;

            fixed4 frag (v2f i) : SV_Target
            {
                float NdotV = 1 - dot(i.normal, i.viewDir) * 1.5; // dot product of normal and view direction, 1.5 is how filled in the mesh is
                return _EdgeColor * NdotV; // multiply by color value to get properly colored pixel
            }

            ENDCG
        }
    }

    Fallback "Diffuse"
}