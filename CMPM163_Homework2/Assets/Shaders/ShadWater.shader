// following TOON-WATER SHADER TUTORIAL: https://roystan.net/articles/toon-water.html
// this shader combines the toon-water shader (from the tutorial) and the reflect shader (from class)

Shader "Custom/ShadWater"
{

    Properties
    {
        // skybox for reflect shader
        _Cube ("Cubemap", CUBE) = "" {}


        // variables for toon-water shader
        _DepthGradientShallow("Depth Gradient Shallow", Color)	 = (0.325, 0.807, 0.971, 0.725)
        _DepthGradientDeep("Depth Gradient Deep", Color) = (0.086, 0.407, 1, 0.749)
        _DepthMaxDistance("Depth Maximum Distance", Float) = 1

        _SurfaceNoise("Surface Noise", 2D) = "white" {}
        _SurfaceNoiseCutoff("Surface Noise Cutoff", Range(0, 1)) = 0.777
        _FoamMaxDistance("Foam Max Distance", Float) = 0.4
        _FoamMinDistance("Foam Min Distance", Float) = 0.04
        _SurfaceNoiseScroll("Surface Noise Scroll Amount", Vector) = (0.03, 0.03, 0, 0)

        _SurfaceDistortion("Surface Distortion", 2D) = "white" {}
        _SurfaceDistortionAmount("Surface Distortion Amount", Range(0, 1)) = 0.27

        _WaterAlpha("Water Alpha", Float) = 1.0
    }
    SubShader
    {
        // needed for transparency in water
        Tags
        {
            "Queue" = "Transparent"
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off

			CGPROGRAM

            #define SMOOTHSTEP_AA 0.01 // for smoothing the cutoff of noise sampling

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                // for toon-water shader
                float4 vertex : SV_POSITION;
                float4 screenPosition : TEXCOORD2;
                float2 noiseUV : TEXCOORD0;
                float2 distortUV : TEXCOORD1;
                float3 viewNormal : NORMAL0;

                // for reflect shader
                float3 normalInWorldCoords : NORMAL1;
                float3 vertexInWorldCoords : TEXCOORD3;
            };

            sampler2D _SurfaceNoise;
            float4 _SurfaceNoise_ST;

            sampler2D _SurfaceDistortion;
            float4 _SurfaceDistortion_ST;

            v2f vert (appdata v)
            {
                v2f o;

                // for toon-water shader
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPosition = ComputeScreenPos(o.vertex);
                o.noiseUV = TRANSFORM_TEX(v.uv, _SurfaceNoise); // get surface noise texture from image
                o.distortUV = TRANSFORM_TEX(v.uv, _SurfaceDistortion); // get surface distortion texture from image
                o.viewNormal = COMPUTE_VIEW_NORMAL;


                // for reflect shader
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
                o.normalInWorldCoords = UnityObjectToWorldNormal(v.normal); //Normal 

                return o;
            }



            // variables for toon-water shader
            float4 _DepthGradientShallow;
            float4 _DepthGradientDeep;

            float _DepthMaxDistance;
            sampler2D _CameraDepthTexture;
            float _SurfaceNoiseCutoff;
            float _FoamMaxDistance;
            float _FoamMinDistance;
            float2 _SurfaceNoiseScroll;

            float _SurfaceDistortionAmount;

            sampler2D _CameraNormalsTexture;


            // variables for reflect shader
            samplerCUBE _Cube;
            float _WaterAlpha;


            fixed4 frag (v2f i) : SV_Target
            {

                // for toon-water shader
                float existingDepth01 = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPosition)).r; // sample depth texture
                float existingDepthLinear = LinearEyeDepth(existingDepth01);

                float depthDifference = existingDepthLinear - i.screenPosition.w; // depth of water surface, relative to screen position

                float waterDepthDifference01 = saturate(depthDifference / _DepthMaxDistance);
                float4 waterColor = lerp(_DepthGradientShallow, _DepthGradientDeep, waterDepthDifference01); // make our water color blend as the water's depth changes

                float3 existingNormal = tex2Dproj(_CameraNormalsTexture, UNITY_PROJ_COORD(i.screenPosition));
                float3 normalDot = saturate(dot(existingNormal, i.viewNormal));

                float foamDistance = lerp(_FoamMaxDistance, _FoamMinDistance, normalDot); 
                float foamDepthDifference01 = saturate(depthDifference / foamDistance); // when dot product is larger, we use a lower foam threshold
                float surfaceNoiseCutoff = foamDepthDifference01 * _SurfaceNoiseCutoff; // where we cutoff whether foam will be drawn for this sample on noise texture

                float2 distortSample = (tex2D(_SurfaceDistortion, i.distortUV).xy * 2 - 1) * _SurfaceDistortionAmount; // distort foam from sampling distortion noise texture

                float2 noiseUV = float2((i.noiseUV.x + _Time.y * _SurfaceNoiseScroll.x) + distortSample.x,
                                        (i.noiseUV.y + _Time.y * _SurfaceNoiseScroll.y) + distortSample.y); // scroll noise surface to "animate" foam
                float surfaceNoiseSample = tex2D(_SurfaceNoise, noiseUV).r; // get current sample of noise texture to see if we apply foam
                float surfaceNoise = smoothstep(_SurfaceNoiseCutoff - SMOOTHSTEP_AA, surfaceNoiseCutoff + SMOOTHSTEP_AA, surfaceNoiseSample); // smooth out cutoff at very end of toon-water shader, to make foam smoother




                // for reflect shader
                float3 P = i.vertexInWorldCoords.xyz;
                
                // get normalized incident ray (from camera to vertex)
                float3 vIncident = normalize(P - _WorldSpaceCameraPos);
                
                // reflect that ray around the normal using built-in HLSL command
                float3 vReflect = reflect( vIncident, i.normalInWorldCoords );
                
                // use the reflect ray to sample the skybox
                float4 reflectColor = texCUBE( _Cube, vReflect );
                
                // refract the incident ray through the surface using built-in HLSL command
                float3 vRefract = refract( vIncident, i.normalInWorldCoords, 0.5 );
                
                float3 vRefractRed = refract( vIncident, i.normalInWorldCoords, 0.1 );
                float3 vRefractGreen = refract( vIncident, i.normalInWorldCoords, 0.1 );
                float3 vRefractBlue = refract( vIncident, i.normalInWorldCoords, 0.7 ); // have most alpha for blue channel, to give water a blue tint
                
                float4 refractColorRed = texCUBE( _Cube, float3( vRefractRed ) );
                float4 refractColorGreen = texCUBE( _Cube, float3( vRefractGreen ) );
                float4 refractColorBlue = texCUBE( _Cube, float3( vRefractBlue ) );
                float4 refractColor = float4(refractColorRed.r, refractColorGreen.g, refractColorBlue.b, 1.0);
                
                
                // get final result from reflection shader and toon-water shader
                // and then lerp them, so we get some of both
                float4 reflectFinal = float4(lerp(reflectColor, refractColor, 0.5).rgb, 1.0);
                float4 toonFinal = waterColor + surfaceNoise;
                return float4(lerp(reflectFinal, toonFinal, 0.4).rgb, _WaterAlpha); // set alpha to _WaterAlpha for this pixel

            }
            ENDCG
        }

    }
}