Shader "Custom/ShadowMapping"
{
    Properties
    {
        _DiffuseColor ("Diffuse Material Color", Color) = (1, 1, 1, 1)
        _ShadowMap ("_ShadowMap", 2D) = "white"
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 proj : TEXCOORD4;
            };

            uniform float4x4 _LightViewMatrix;
            uniform float4x4 _LightprojectionMatrix;
            uniform sampler2D _ShadowMap;

            v2f vert (appdata v)
            {
                v2f output;

                float4 lightPos = float4(unity_4LightPosX0[0], unity_4LightPosY0[0], unity_4LightPosZ0[0], 1.0);

                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
                float3 worldNormal = normalize(mul(float4(v.normal, 0), transpose(unity_WorldToObject)).xyz);

                float3 lightDirection = normalize((lightPos - worldPos).xyz);

                float4x4 constantMatrix = {0.5, 0, 0, 0.5,
                                           0, 0.5, 0, 0.5,
                                           0, 0, 0.5, 0.5,
                                           0, 0, 0,     1};
                float4x4 textureMatrix = mul(mul(constantMatrix, _LightprojectionMatrix), _LightViewMatrix);

                output.vertex = UnityObjectToClipPos(v.vertex);
                output.uv = ComputeScreenPos(output.vertex);
                output.proj = mul(textureMatrix, worldPos);
                
                return output;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 shadowCoef = tex2Dproj(_ShadowMap, i.proj);

                if (shadowCoef.r == 1 && shadowCoef.g == 1 && shadowCoef.b == 1)
                {
                    shadowCoef = float4(1, 1, 1, 1);
                }
                else
                {
                    shadowCoef = float4(0, 0, 0, 1);
                }

                return shadowCoef;
            }
            ENDCG
        }
    }
}
