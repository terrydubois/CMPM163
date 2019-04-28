Shader "Custom/OutputTexture"
{
    Properties
    {
		// allow us to pull a texture in
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
		// define "type" of shader
        Tags { "RenderType" = "Opaque" }
        
		Pass
		{
			// program written in CG language
			CGPROGRAM
			// decalre vertex and fragment functions
			#pragma vertex vert
			#pragma fragment frag

			// include common shader functions
			#include "UnityCG.cginc"

			// declare type "appdata" to take in data from unity
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv: TEXCOORD0;
			};

			// declare type "v2f" to convert vertex to fragment
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv: TEXCOORD0;
			};

			// declare a 2D texture
			sampler _MainTex;

			// function to take vertex data from Unity and converts it
            // to camera's coordinates so it can be passed to GPU
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			// function that takes in GPU-optimized vertex data and will return
            // fixed4 (smaller bit-size than float4) which holds color and alpha channels
			fixed4 frag(v2f i) : SV_Target
			{
				// get float4 of current cell
				float4 c = tex2D(_MainTex, i.uv);

				// return float4 with RGBA channels
                return float4(c.r, c.g, c.b, c.a);
			}
			
			// done writing in CG
			ENDCG
		}
      
    }
    FallBack "Diffuse"
}
