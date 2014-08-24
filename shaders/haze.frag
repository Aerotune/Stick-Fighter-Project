#version 110
uniform sampler2D in_Texture;
varying vec2 var_TexCoord;
uniform float in_Time;
uniform float in_Strength;
uniform float in_Width;
uniform float in_Height;

void main()
{
 	 vec2 offset = vec2(0.0);
	 offset.x = (sin(in_Time*1.9  + var_TexCoord.y*in_Height/1.7)/in_Width*1.3 +
	             sin(in_Time*3.61 + var_TexCoord.y*in_Height/8.0)/in_Width*1.6) * in_Strength;
	 vec4 pixelColor = texture2D(in_Texture, var_TexCoord + offset);
	 
	 if(pixelColor.a > 0.0 && pixelColor.a < 1.0) {
	 	 // workaround to fix alpha color
	 	 // i think it might be a gosu/ashton problem with
	 	 // doing premultiplied alpha twice
	   pixelColor.rgb /= pow(pixelColor.a, 0.5); 
	 }
	 gl_FragColor = pixelColor;
}