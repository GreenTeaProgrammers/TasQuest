 	Shader "Custom/AlphaDependingCameraDistance"
{
    Properties
    {
        _Color("Debug COlor", Color) = (0.0, 0.0, 0.0, 1.0)
        _MainTex ("Texture", 2D) = "white" {}
        _Radius ("Radius", Range(0.01, 10)) = 2.0
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "RenderType"="Transparent" }

        Blend SrcAlpha OneMinusSrcAlpha

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
                float4 modelOrigin : TEXCOORD2;
            };

            float _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float _Radius;

            fixed4 frag(v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv);
                float dist = distance(i.worldPos, _WorldSpaceCameraPos);
                col.a = saturate(dist*_Radius);
                return col;
            }

            ENDCG
        }
    }
}