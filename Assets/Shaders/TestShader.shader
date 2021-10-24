Shader "Unlit/TestShader"
{
    Properties
    {
        //_MainTex ("Texture hi", 2D) = "white" {}
        
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (0,0,0,0)
        _ColorStart("Color Start", Range(0,1)) = 0
        _ColorEnd ("Color End", Range(0,1)) = 1
        }
    SubShader
    {
        Tags { "RenderType"="Transparent"
            "Queue"="Transparent" }
        Pass
        {
            
            Cull off
            Zwrite Off
            ZTest Always
            Blend One One
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #define TAU 6.28318530718
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };
            //sampler2D _MainTex;
            //float4 _MainTex_ST;
            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;  //(v.uv + _Offset) * _Scale;

                o.normal = mul((float3x3) unity_ObjectToWorld, v.normal);
                return o;
            }
            
            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }
            
            float4 frag (v2f i) : SV_Target
            {
                //float4 col = tex2D(_MainTex, i.uv);
                //i.uv.x *= cos(_Time.y);

                //float t = saturate(InverseLerp(_ColorStart, _ColorEnd, i.uv.x));

                float xOffset = cos(i.uv.x * TAU * 8) * 0.01;
                float t = cos((i.uv.y + xOffset - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;

                t *= 1- i.uv.y;
                //return t;

                bool topBottomRemover = (abs(i.normal.y) < 0.999);
                float waves = t * topBottomRemover;
                float4 outColor = lerp(_ColorA,_ColorB,waves);
                return float4(outColor.xyz,1);
                //return outColor; //float4(i.uv,0,1);
                
                //return float4(i.uv,0.5,0.2);
                // 0 - u - x - r
                // 1 - v - y - g
                // 2 -   - z - b
                // 3 -   - w - a
            }
            ENDCG
        }
    }
}