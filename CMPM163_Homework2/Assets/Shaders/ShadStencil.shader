Shader "Custom/ShadStencil"
{
    Properties {
        _Color("Color", Color) = (1, 1, 1)
    }

    SubShader {

        Stencil
        {
            Ref 1
            Comp Always
            Pass Replace
            ZFail Keep
        }

        Color [_Color]
        Pass {}
    }
}