#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

#define USE_LIGHTING
 
struct appdata
{
    float4 vertex : POSITION;
    float3 normal: NORMAL;
    float4 tangent : TANGENT; //xyz = tangent direction, w = tangent sign
    float2 uv : TEXCOORD0;
};
 
struct v2f
{
    float4 vertex : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : TEXCOORD1;
    float3 tangent : TEXCOORD2;
    float3 bitangent : TEXCOORD3;
    float3 worldPosition : TEXCOORD4;
    LIGHTING_COORDS(5,6)
};
 
sampler2D _MainTex;
sampler2D _Normals;
float4 _MainTex_ST;
float _Gloss;
float4 _Color;
float _Mag;
float _Str;
 
v2f vert (appdata v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.normal = UnityObjectToWorldNormal(v.normal);
    o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
    o.bitangent = cross(o.normal, o.tangent) * (v.tangent.w * unity_WorldTransformParams.w); //Correctly handle flipping/mirroring
    o.worldPosition = mul( unity_ObjectToWorld, v.vertex);
    TRANSFER_VERTEX_TO_FRAGMENT(o); //lighting
    return o;
}
 
fixed4 frag (v2f i) : SV_Target
{
    float3 albedo = tex2D(_MainTex, i.uv);
    float3 surfaceColor = albedo * _Color.rgb;

    
    float3 tangentSpaceNormal = UnpackNormal(tex2D(_Normals, i.uv));

    //x = tangent
    //y = bitangent
    //z = normal
    float3x3 mtxTangToWorld =
    {
        i.tangent.x, i.bitangent.x, i.normal.x,
        i.tangent.y, i.bitangent.y, i.normal.y,
        i.tangent.z, i.bitangent.z, i.normal.z,
    };

    float3 N = mul(mtxTangToWorld, tangentSpaceNormal);
    
    #ifdef USE_LIGHTING
    //diffuse Lighting
    //lambert
    //float3 N = normalize( i.normal);
    float3 L = normalize(UnityWorldSpaceLightDir(i.worldPosition)); //actually a direction to the light source
    float attenuation = LIGHT_ATTENUATION(i);
    //return float4(L,1);
    float3 lambert = saturate(dot(N,L));
    float3 diffuseLight = (lambert * attenuation) * _LightColor0.xyz;
    //saturate 0-1  can also work //clamp01 = saturate
    
    //blinn phong
    float3 V = normalize(_WorldSpaceCameraPos - i.worldPosition);
    float3 H = normalize(L + V);
    float3 specularLight = saturate(dot(H,N)) * (lambert > 0);
    float specularExponent = exp2(_Gloss * 11) + 2;
    specularLight = pow(specularLight, specularExponent) * _Gloss * attenuation;
    specularLight *= _LightColor0.xyz;
                
    //fresnel
    float fresnel = (1 - dot(V,N));// * (cos(_Time.y * 4)) * _Mag + _Str;
    
    return float4(diffuseLight * surfaceColor + specularLight,1);
    
    #else
        #if IS_IN_BASE_PASS
            return surfaceColor;
        #else
            return 0;
        #endif
    
    #endif
}