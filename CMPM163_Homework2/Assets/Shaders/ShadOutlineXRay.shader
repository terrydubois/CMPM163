Shader "Custom/OutlineXRay"
{
    Properties
    {
        _EdgeColor("Edge Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Stencil
        {
            Ref 0
            Comp NotEqual
        }

        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "XRay" = "ColoredOutline"
        }

        ZWrite Off
        ZTest Always
        Blend One One // additive blending

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
                output.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
                return output;
            }

            float4 _EdgeColor;

            fixed4 frag (v2f i) : SV_Target
            {
                float NdotV = 1 - dot(i.normal, i.viewDir) * 1.5;
                return _EdgeColor * NdotV;
            }

            ENDCG
        }
    }

    Fallback "Diffuse"
}