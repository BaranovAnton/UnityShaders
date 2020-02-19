Shader "Unlit/UnlitGridShader"
{
	Properties
	{
		_LineColor("Line Color", Color) = (0,0,0,1)
		//_CellColor("CellColor", Color) = (1,1,1,1) // если необходим будет цвет ячеек
		[IntRange] _GridSize("Grid Size", Range(1,100)) = 10
		_LineSize("Line Size", Range(0,1)) = 0.1
	}
		SubShader
	{
		Cull Off
		ZWrite Off
		ZTest Always

		Pass
		{
			CGPROGRAM

			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 _LineColor;
			float4 _CellColor;
			float4 col;

			float _GridSize;
			float _LineSize;

			fixed4 frag(v2f_img i) : COLOR
			{
				float gsize = _GridSize + _LineSize;
				float2 id;		

				id.x = floor(i.uv.x / (1.0 / gsize));
				id.y = floor(i.uv.y / (1.0 / gsize));

				if (frac(i.uv.x*gsize) <= _LineSize || frac(i.uv.y*gsize) <= _LineSize)
				{
					col = _LineColor;
				}
				else {
					//col = _CellColor; // цвет ячеек
					discard;
				}

				return col;
			}
			ENDCG
		}
	}
}
