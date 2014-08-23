#version 110
// http://www.gamerendering.com/2008/10/11/gaussian-blur-filter-shader/
uniform sampler2D in_Texture;
varying vec2 var_TexCoord;
uniform float in_Height;
float blurSize = 1.0/in_Height;

void main()
{
   vec4 sum = vec4(0.0);
 	 
   sum += texture2D(in_Texture, vec2(var_TexCoord.x, var_TexCoord.y - 4.0*blurSize)) * 0.05;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x, var_TexCoord.y - 3.0*blurSize)) * 0.09;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x, var_TexCoord.y - 2.0*blurSize)) * 0.12;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x, var_TexCoord.y - blurSize))     * 0.15;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x, var_TexCoord.y))                * 0.165;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x, var_TexCoord.y + blurSize))     * 0.15;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x, var_TexCoord.y + 2.0*blurSize)) * 0.12;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x, var_TexCoord.y + 3.0*blurSize)) * 0.09;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x, var_TexCoord.y + 4.0*blurSize)) * 0.05;
 
   gl_FragColor = sum;
}