Shader "Unlit/ImageShader"
{
	Properties
	{
		_BoundColor("Bound Color", Color) = (1,1,1,1)
		_BgColor("Background Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_BoundWidth("BoundWidth", float) = 0.1

		[Enum(Rectangle,1,Circle,2,Ellipse,3)] _imageShape("Image Shape", Float) = 1
	}
		SubShader{

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag Lambert alpha

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float _BoundWidth;
			fixed4 _BoundColor;
			fixed4 _BgColor;
			float _imageShape;

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

			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 c = tex2D(_MainTex,i.uv);
				float x = i.uv.x;
				float y = i.uv.y;
				_BoundWidth *= 0.5;

				// прямоугольник
				if (_imageShape == 1) {	
					float ratio = _MainTex_TexelSize.x / _MainTex_TexelSize.y;
					float ratioX = 2; // c.z / c.w;
					float ratioY = 0.5;
					//if (x > 1.0 - _BoundWidth || y > 1.0 - _BoundWidth || x < _BoundWidth || y < _BoundWidth)
					if (x > 1.0 - _BoundWidth / ratio || y > 1.0 - _BoundWidth)
						c = _BoundColor;
					else
						c = _BgColor;
				}

				// окружность
				if (_imageShape == 2) {
					float dis = sqrt(pow((0.5 - x), 2) + pow((0.5 - y), 2));
					if (dis > 0.5) {
						discard;
					}
					else {
						float innerRadius = 0.5 - _BoundWidth;
						if (dis > innerRadius)
							c = _BoundColor;
						else
							c = _BgColor;
					}
				}

				// эллипс
				if (_imageShape == 3) {			
					/*float dis = pow(x, 2) / pow(c.z * 0.5, 2) + pow(y, 2) / pow(c.w * 0.5, 2);
					if (dis * 0.5 > 1.0) {
						discard;
					}
					else {
						float innerRadius = 0.5 - _BoundWidth;
						if (dis > innerRadius)
							c = _BoundColor;
						else
							c = _BgColor;
					}*/
				}

				return c;
			}

		ENDCG
		}
	}
}