// Noise Shader Library for Unity - https://github.com/keijiro/NoiseShader
//
// Original work (webgl-noise) Copyright (C) 2011 Stefan Gustavson
// Translation and modification was made by Keijiro Takahashi.

Shader "Custom/ShadNoise"
{
    Properties
    {
       _NoiseO("Noise O", Float) = 0.0
        _NoiseS("Noise S", Float) = 1.0
        _NoiseW("Noise W", Float) = 0.5
    }

    CGINCLUDE


    #pragma multi_compile CNOISE PNOISE SNOISE SNOISE_AGRAD SNOISE_NGRAD
    #pragma multi_compile _ THREED
    #pragma multi_compile _ FRACTAL

    #include "UnityCG.cginc"
    #include "ClassicNoise2D.hlsl"

    v2f_img vert(appdata_base v)
    {
        v2f_img o;
        o.pos = UnityObjectToClipPos(v.vertex);
        o.uv = v.texcoord.xy;
        return o;
    }

    float _NoiseO;
    float _NoiseS;
    float _NoiseW;

    float4 frag(v2f_img i) : SV_Target
    {
        const float epsilon = 0.0001;

        float2 uv = i.uv * 10.0 + float2(0.5, 1) * _Time.y;
        float o = _NoiseO;
        float s = _NoiseS;
        float w = _NoiseW;


        #ifdef FRACTAL
        for (int i = 0; i < 6; i++)
        #endif
        {
            #if defined(THREED)
                float3 coord = float3(uv * s, _Time.y);
                float3 period = float3(s, s, 1.0) * 2.0;
            #else
                float2 coord = uv * s;
                float2 period = s * 2.0;
            #endif

            #if defined(CNOISE)
                o += cnoise(coord) * w;
            #endif

            s *= 2.0;
            w *= 0.5;
        }

        return float4(o, o, o, 0);
        
    }

    ENDCG
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }

}
