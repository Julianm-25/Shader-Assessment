Shader "Unlit/LightingMulti"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [NoScaleOffset] _Normals("Normal Map", 2D) = "bump" {}
        _Gloss("Gloss", range(0,1)) = 1
        _Color("Colour", color) = (1,1,1,1)
        _Mag("Mag", range(0,1)) = 0.5
        _Str("Str", range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        //Base pass
        Pass
        {
            Tags {"LightMode" = "ForwardBase"}
            //"Always"
            //"ForwardAdd"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #define IS_IN_BASE_PASS
            
            #include "IncludeLighting.cginc"
            
            ENDCG
        }
        //Add Pass
        Pass
        {
            Blend One One //src *1 + dst
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd

            #include "IncludeLighting.cginc"
            
            ENDCG
        }
    }
}