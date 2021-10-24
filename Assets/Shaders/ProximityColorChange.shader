Shader "Unlit/ProximityColorChange"
{
    Properties
    {
        _PlayerPos ("Player position", vector) = (0.0, 0.0, 0.0, 0.0)
        _Dist ("Distance", float) = 5.0
        _MainTex ("Texture", 2D) = "white" {}
        _Color1("Colour 1", color) = (0,1,0,1)
        _Color2("Color 2", color) = (1,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
       
        Pass
        {
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
            float _Dist;
            float4 _Color1;
            float4 _Color2;

            
            fixed4 frag(v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv)* lerp(_Color2, _Color1, _Dist/10); 
            }
 
            ENDCG
        }
    }
}
