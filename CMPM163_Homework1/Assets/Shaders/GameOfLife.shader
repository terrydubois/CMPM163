Shader "Custom/GameOfLife"
{
	Properties
	{
        // allow us to pull a texture in
		_MainTex("Texture", 2D) = "white" {} 
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
            
            uniform float4 _MainTex_TexelSize;
           
            // declare type "appdata" to take in data from unity
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv: TEXCOORD0;
			};

            // declare type "v2f" to convert vertex to fragment
			struct v2f
			{
                // SV_POSITION will make it to be processed by GPU
				float4 vertex : SV_POSITION;
                // TEXCOORD0 is coordinate relative to texture
				float2 uv: TEXCOORD0;
			};

            // function to take vertex data from Unity and converts it
            // to camera's coordinates so it can be passed to GPU
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
            
            // declare a 2D texture
            sampler2D _MainTex;
            
            // function that takes in GPU-optimized vertex data and will return
            // fixed4 (smaller bit-size than float4) which holds color and alpha channels
			fixed4 frag(v2f i) : SV_Target
			{
            
                // define texel, which is a float2 with the X and Y size of the Main Textures
                float2 texel = float2(
                    _MainTex_TexelSize.x, 
                    _MainTex_TexelSize.y 
                );
                
                // get texture coordinates of current vertex
                float cx = i.uv.x;
                float cy = i.uv.y;
                
                // get the color of that vertex
                float4 C = tex2D( _MainTex, float2( cx, cy ));   
                
                // get the positions up, down, right, left relative to current vertex
                float up = i.uv.y + texel.y * 1;
                float down = i.uv.y + texel.y * -1;
                float right = i.uv.x + texel.x * 1;
                float left = i.uv.x + texel.x * -1;
                
                // declare array of 8 values to hold the colors of the surrounding vertices
                float4 arr[8];
                arr[0] = tex2D(  _MainTex, float2( cx   , up ));   //N
                arr[1] = tex2D(  _MainTex, float2( right, up ));   //NE
                arr[2] = tex2D(  _MainTex, float2( right, cy ));   //E
                arr[3] = tex2D(  _MainTex, float2( right, down )); //SE
                arr[4] = tex2D(  _MainTex, float2( cx   , down )); //S
                arr[5] = tex2D(  _MainTex, float2( left , down )); //SW
                arr[6] = tex2D(  _MainTex, float2( left , cy ));   //W
                arr[7] = tex2D(  _MainTex, float2( left , up ));   //NW

                // scan through array, count the amount of vertices
                // that are yellow (have both red and green channels)
                int cnt = 0;
                for (int i = 0; i < 8; i++) {
                    if (arr[i].r > 0.5 && arr[i].g > 0.5) {
                        cnt++;
                    }
                }
                    

                // the cell is alive if it is yellow or white (R & G)
                if (C.r >= 0.5 && C.g >= 0.5) {
                    if (cnt == 2 || cnt == 3) {
                        //Any live cell with two or three live neighbours lives on to the next generation.
                
                        // in this case, return yellow (R & G)
                        return float4(1.0, 1.0, 0.0, 1.0);
                    }
                    else {
                        //Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
                        //Any live cell with more than three live neighbours dies, as if by overpopulation.

                        // in this case, return blue (B)
                        return float4(0.0, 0.0, 1.0, 1.0);
                    }
                }
                // the cell is dead if it is not yellow or white (R & G)
                else { //cell is dead
                    if (cnt == 3) {
                        //Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

                        // in this case, return white (R & G & B)
                        return float4(1.0, 1.0, 1.0, 1.0);
                    }
                    else {

                        // in this case, return blue (B)
                        return float4(0.0, 0.0, 1.0, 1.0);

                    }
                }
                
            }

            // done writing in CG
			ENDCG
		}

	}
	FallBack "Diffuse"
}