﻿// This comes from the Bloom shader made in CMPM163 section

Shader "Custom/ShadBloom"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BaseTex ("Texture", 2D) = "white" {}
        _Steps ("Steps", Float) = 3
        
    }
    SubShader
    {
        //Bright pass
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            uniform float4 _MainTex_TexelSize; //special value
          
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                float3 col = tex2D( _MainTex, i.uv).rgb;
                // get luminance
                float brightness = dot(col, float3(0.2126, 0.7152, 0.0722)); // values are chosen based on strength of color channels in human eye cones

                // if luminance is greater than our threshold, return color with full alpha,
                // else return black
                if (brightness > 1.0) {
                    return float4(col, 1.0);
                }
                else {
                    return float4(0, 0, 0, 1);
                }
                
            }
            ENDCG
        }
        
        // Blur pass - This is a box blur which affect the performance
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            uniform float4 _MainTex_TexelSize; //special value
            uniform float _Steps;
            
            sampler2D _MainTex;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            

            fixed4 frag (v2f i) : SV_Target
            {
                float2 texel = float2(
                    _MainTex_TexelSize.x, 
                    _MainTex_TexelSize.y 
                );
        
        
                float3 avg = 0.0;
        
                int steps = ((int)_Steps) * 2 + 1;
                if (steps < 0) {
                    avg = tex2D( _MainTex, i.uv).rgb;
                }
                else {
                    int x, y;
            
                    // average out near pixels for blurring effect
                    for ( x = -steps/2; x <=steps/2 ; x++) {
                        for (int y = -steps/2; y <= steps/2; y++) {
                            avg += tex2D( _MainTex, i.uv + texel * float2( x, y ) ).rgb;
                        }
                    }
            
                    avg /= steps * steps;
                }             
        
                return float4(avg, 1.0);
               
            }
            ENDCG
        }
        
        //Combine pass
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            
            sampler2D _MainTex;
            sampler2D _BaseTex;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

        
            fixed4 frag (v2f i) : SV_Target
            {
                //Combine _MainTex color and _BaseTex color
                float4 original = tex2D(_MainTex, i.uv);
                float4 blur = tex2D(_BaseTex, i.uv);
                return original + blur;
            }
            ENDCG
        }
    }
}
