//Rotation matrices taken from Wikipedia page (https://en.wikipedia.org/wiki/Rotation_matrix)
Shader "Custom/VertexRotation"
{
    // speed variable to control in inspector
    Properties
    {
        _Speed ("Speed", Float) = 10.0
    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            
            uniform float _Speed;
           
            // appdata information taken in from Unity
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal: NORMAL;
            };

            // convert vertex to fragment for use in our fragment shader
            struct v2f
            {
                float4 vertex : SV_POSITION;  
                float3 normal : NORMAL;
                float timeVal : Float;
            };
            
            // get matrix of angled X coordinates
            float3x3 getRotationMatrixX (float theta) {
                
                float s = -sin(theta);
                float c = cos(theta);
                return float3x3(1, 0, 0, 0, c, -s, 0, s, c);
            }
            
            // get matrix of angled Y coordinates
            float3x3 getRotationMatrixY (float theta) {
                
                float s = -sin(theta);
                float c = cos(theta);
                return float3x3(c, 0, s, 0, 1, 0, -s, 0, c) ;
            }
            
            // get matrix of angled Z coordinates
            float3x3 getRotationMatrixZ (float theta) {
                
                float s = -sin(theta);
                float c = cos(theta);
                return float3x3(c, -s, 0, s, c, 0, 0, 0, 1);
            }
            
            // constructor for v2f so we can 
            v2f vert (appdata v)
            {
                v2f o;
                
                // rotate mesh
                const float PI = 3.14159;
                float rad = fmod(_Time.y * _Speed, PI*2.0);
                float3x3 rotationMatrix = getRotationMatrixX(rad);
                float3 rotatedVertex = mul(rotationMatrix, v.vertex.xyz);
                float4 xyz = float4( rotatedVertex, 1.0 );
               
                // convert to clip space
                o.vertex = UnityObjectToClipPos(xyz);
                o.normal = v.normal;
               
                return o;
            }

            // take normal and output color
            float4 normalToColor (float3 n) {
                return float4( (normalize(n) + 1.0) / 2.0, 1.0) ;
            }

            // no need to change color much, so fragment shader is 1 line
            fixed4 frag (v2f i) : SV_Target
            {
                return normalToColor(i.normal);
            }
            ENDCG
        }
    }
}
