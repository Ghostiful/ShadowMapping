Shader "Custom/ShadowShader"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
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
                float4 scrPos : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _CameraDepthTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.scrPos = ComputeScreenPos(o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float depthVal = Linear01Depth(tex2D(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)).r);
                fixed4 depth;

                depth.r = depthVal;
                depth.g = depthVal;
                depth.b = depthVal;
                depth.a = 1;

                return depth;
            }
            ENDCG
        }
    }
}
