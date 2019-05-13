// following tutorial: https://www.youtube.com/watch?v=OJkGGuudm38

Shader "Custom/ShadStencil"
{
    Properties {
        _Color("Color", Color) = (0, 0, 0, 1) // color of X-Ray plane
    }

    SubShader {

        // needed for creating x-ray effect
        Stencil
        {
            Ref 1 // value passed to screen buffer
            Comp Always // tell engine to compare reference value to current value
            Pass Replace // if this shader is being stenciled, replace it with the shader specified
            ZFail Keep // what to do with the contents of buffer if stencil test passes, but depth test fails
        }

        // the simplest shader ever for this plane: make this material an unlit color
        Color [_Color]
        Pass {}
    }
}