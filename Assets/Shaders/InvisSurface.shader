Shader "Unlit/InvisSurface"
{
    Properties
    {
        _PlayerPos ("Player position", vector) = (0.0, 0.0, 0.0, 0.0)
        _Dist ("Distance", float) = 5.0
        _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
        _SecondaryTex ("Secondary texture", 2D) = "white"{}
        _Color ("Color", color) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True"}
       
        Pass
        {
            ColorMask RGB
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
            };
 
            v2f vert(appdata_base v)
            {
                v2f o;
                // We compute the world position to use it in the fragment function
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }
 
            float4 _PlayerPos;
            sampler2D _MainTex;
            sampler2D _SecondaryTex;
            float _Dist;
            float4 _Color;
            
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.a = 0;
                // Depending the distance from the player, we use a different texture
                if(distance(_PlayerPos.xyz, i.worldPos.xyz) < _Dist)
                    return tex2D(_MainTex, i.uv);
                else
                    return _Color;
            }
 
            ENDCG
        }
    }
}
