Shader "Custom/Outline"
{
    Properties
    {
        _Outline("Outline", Float) = 0
        _OutlineColor("OutlineColor", Vector) = (0, 0.5, 1, 1)
    }
    SubShader
    {
        Pass
        {
            Cull front

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _Outline;
            float4 _OutlineColor;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler _MainTex;
            
            v2f vert (appdata v)
            {
                
                v2f o;
                v.vertex += float4(v.normal, 1.0) * _Outline;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 c = tex2D(_MainTex, i.uv);
                return _OutlineColor;//float4(0, 0.5, 1, 1); // RGBA color of outline
            }
            

            ENDCG
        }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _Outline;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler _MainTex;
            
            v2f vert (appdata v)
            {
                
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 c = tex2D(_MainTex, i.uv);
                return float4(0, 0, 0, 0); // RGBA color of fill
            }
            

            ENDCG
        }

        
    }
}
