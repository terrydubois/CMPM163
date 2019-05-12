Shader "Custom/ShadTronGround"
{
    Properties {
        _Color("Color", Color) = (1, 1, 1)
    }

    // This ultra-simple shader just gives the material the unlit given color
    SubShader {
        Color [_Color]
        Pass {}
    }
}