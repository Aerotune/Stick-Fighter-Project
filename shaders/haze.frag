#version 110
uniform sampler2D in_Texture;
varying vec2 var_TexCoord;
uniform float in_Time;
uniform float in_Strength;

void main()
{
 	 vec2 offset = vec2(0.0);
	 offset.x = (sin(in_Time*2.0+var_TexCoord.y*50.0)/325.0 + sin(in_Time*4.3+var_TexCoord.y*250.0)/600.0) * in_Strength;
	 vec4 pixelColor = texture2D(in_Texture, var_TexCoord + offset);
	 
	 if(pixelColor.a > 0.0 && pixelColor.a < 1.0) {
		 // workaround to fix alpha color
		 // i think it might be a gosu/ashton problem with
		 // doing premultiplied alpha twice
	   pixelColor.rgb /= pow(pixelColor.a, 0.5); 
	 }
	 gl_FragColor = pixelColor;
}