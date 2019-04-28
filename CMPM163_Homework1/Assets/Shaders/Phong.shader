
//Adapted from Example 5.3 in The CG Tutorial by Fernando & Kilgard
Shader "Custom/Phong"
{
    // Define uniform variables for Phong: color, shininess, specular highlight
    Properties
    {   
        _Color ("Color", Color) = (1, 1, 1, 1)              // object's color
        _Shininess ("Shininess", Float) = 10                // object's Shininess
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1) // color of specular highlights
    }
    
    SubShader
    {
        Pass {
            //In Unity, point lights are calculated in the the ForwardAdd pass
            Tags { "LightMode" = "ForwardAdd" }
          
            // tell unity we are using Cg and the names of our
            // vertex and fragment shaders
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // include many Unity uniform variables
            #include "UnityCG.cginc"
            
            // define our own uniform variables
            uniform float4 _LightColor0;
            uniform float4 _Color; 
            uniform float4 _SpecColor;
            uniform float _Shininess;          
          
            // struct for information from Unity's mesh
            struct appdata
            {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
            };

            // struct for v2f, so we can give our fragment shader converted
            // coordinates
            struct v2f
            {
                    float4 vertex : SV_POSITION;
                    float3 normal : NORMAL;       
                    float3 vertexInWorldCoords : TEXCOORD1;
            };

            // constructor for v2f, will convert vertex position to world coordinates
           v2f vert(appdata v)
           { 
                v2f o;
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex);
                o.normal = v.normal; //Normal 
                o.vertex = UnityObjectToClipPos(v.vertex);

                return o;
           }

           // fragment shader, will return RGBA values
           fixed4 frag(v2f i) : SV_Target
           {
                // get coordinate information from v2f
                float3 P = i.vertexInWorldCoords.xyz;
                float3 N = normalize(i.normal);
                float3 V = normalize(_WorldSpaceCameraPos - P);
                float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
                float3 H = normalize(L + V);
                
                // get color, shininess, and specular highlights from uniform variables
                float3 Kd = _Color.rgb;
                float3 Ka = UNITY_LIGHTMODEL_AMBIENT.rgb;
                float3 Ks = _SpecColor.rgb;
                float3 Kl = _LightColor0.rgb;
                
                // ambient light is the RGB from uniform
                float3 ambient = Ka;
               
                // diffuse lighting is the dot product of
                // the normalized normal coordinates and normalized worldSpaceLighPos
                float diffuseVal = max(dot(N, L), 0);
                float3 diffuse = Kd * Kl * diffuseVal;
                 
                // specular lighting is similar, but with adjusted angle and
                // raised to the power of uniform shininess
                float specularVal = pow(max(dot(N,H), 0), _Shininess);
                
                if (diffuseVal <= 0) {
                    specularVal = 0;
                }
                
                float3 specular = Ks * Kl * specularVal;
                
                //FINAL COLOR OF FRAGMENT
                return float4(ambient + diffuse + specular, 1.0);
            }
            
            ENDCG
        }
            
    }
}
