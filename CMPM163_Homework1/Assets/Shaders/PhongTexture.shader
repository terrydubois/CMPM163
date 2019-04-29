// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/PhongTexture"
{
    Properties
    {
        // declare main variables for Phong
        _Color ("Color", Color) = (1,1,1,1)
        _SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
        _Shininess("Shininess", Float) = 1.0
        
        // able to bring in texture
        _MainTex ("Main Tex", 2D) = "white" {}
        
    }
    SubShader
    {
        pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            // colors will be float4 for RGBA, shininess will just be a single float
            float4 _LightColor0;
            float4 _Color;
            float4 _SpecularColor;
            float _Shininess;
            sampler2D _MainTex;
            

            // declare type so we can get the positions of vertices being input
            struct vertexShaderInput 
            {
                float4 position: POSITION;
                float3 normal: NORMAL; 
                float2 uv: TEXCOORD0;
            };
            
            // declare type of output
            struct vertexShaderOutput
            {
                float4 position: SV_POSITION;
                float3 normal: NORMAL;
                float3 vertInWorldCoords: float3;
                float2 uv: TEXCOORD0;
            };
            
            // constructor for output type
            vertexShaderOutput vert(vertexShaderInput v)
            {
                vertexShaderOutput o;
                o.vertInWorldCoords = mul(unity_ObjectToWorld, v.position);
                o.position = UnityObjectToClipPos(v.position);
                o.normal = v.normal;
                o.uv = v.uv;
                return o;
            }
            
            // fragment shader returns color, so type is float4
            float4 frag(vertexShaderOutput i):SV_Target
            {
                // phong is a combination of ambient, diffuse, and speculuar color

                // set ambient from global ambient
                float3 Ka = float3(1, 1, 1);
                float3 globalAmbient = float3(0.8, 0.1, 0.1);
                float3 ambientComponent = Ka * globalAmbient;

                // set diffuse from the normal of inputted coordinates
                float3 P = i.vertInWorldCoords.xyz;
                float3 N = normalize(i.normal);
                float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
                float3 Kd = _Color.rgb;
                float3 lightColor = _LightColor0.rgb;
                float3 diffuseComponent = Kd * lightColor * max(dot(N, L), 0);
                
                // set speculuar highlight and do matrix calculation to  get specular component
                float3 Ks = _SpecularColor.rgb;
                float3 V = normalize(_WorldSpaceCameraPos - P);
                float3 H = normalize(L + V);
                float3 specularComponent = Ks * lightColor * pow(max(dot(N, H), 0), _Shininess);
                
                // add ambient + diffuse + specular to get final color for this fragment
                float3 finalColor = ambientComponent + diffuseComponent + specularComponent;
                
                return float4(finalColor, 1.0) * tex2D(_MainTex, i.uv);
            }
            
            ENDCG
        }
    }
    FallBack "Diffuse"
}