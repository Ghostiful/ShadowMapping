Shader "Custom/ShadowMapper"
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            uniform float4x4 _LightViewMatrix;
            uniform float4x4 _LightprojectionMatrix;
            uniform sampler2D _ShadowMap;

            v2f vert (appdata v)
            {
                v2f output;
                output.vertex = mul(mul(float4(v.vertex.xyz, 1.0), unity_ObjectToWorld), _LightprojectionMatrix);
                output.uv = ComputeScreenPos(output.vertex);
                
                return output;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 output;

                float3 sampleCoord = i.vertex.xyz / i.vertex.w;

                float depth = sampleCoord.z;
                float shadowMapDepth = tex2D(_ShadowMap, sampleCoord.xy).r;

                if (depth < shadowMapDepth)
                {
                    output = fixed4(1, 1, 1, 1);
                }
                else
                {
                    output = fixed4(0, 0, 0, 1);
                }

                return output;
            }
            ENDCG
        }
    }
}
