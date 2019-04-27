Shader "Custom/Blur"
{
    Properties
    {
        // declare texture and steps variable (amount of blur steps)
        _MainTex ("Texture", 2D) = "white" {}
        _Steps ("Steps", Float) = 3
        
    }
    SubShader
    {
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            uniform float4 _MainTex_TexelSize; //special value
            uniform float _Steps;
            
            // declare type "appdata" to take in data from unity
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            // declare type "v2f" to convert vertex to fragment
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            // function to take vertex data from Unity and converts it
            // to camera's coordinates so it can be passed to GPU
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            // function to return blurre texel
            fixed4 frag (v2f i) : SV_Target
            {
                // define texel as float2 with our TexelSize XY values
                float2 texel = float2(
                    _MainTex_TexelSize.x, 
                    _MainTex_TexelSize.y 
                );
        
        
                float3 avg = 0.0;

                // cast _Steps to int
                int steps = ((int)_Steps) * 2 + 1;

                // if steps < 0, return the texel's color channel values as they are
                if (steps < 0) {
                    avg = tex2D( _MainTex, i.uv).rgb;
                }
                else {
            
                    // if steps >= 0, we calculate and return the average colors of near texels
                    int x, y;
                    for ( x = -steps / 2; x <= steps / 2 ; x++) {
                        for (int y = -steps / 2; y <= steps / 2; y++) {
                            avg += tex2D( _MainTex, i.uv + texel * float2( x, y ) ).rgb;
                        }
                    }
            
                    avg /= steps * steps;
                }             

                // avg is a float3 (for r,g,b) so we give it one more value (alpha)
                // and not we can return the float4
                return float4(avg, 1.0);
        
            }
            ENDCG
        }
    }
}
