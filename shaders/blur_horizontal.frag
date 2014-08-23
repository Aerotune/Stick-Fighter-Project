#version 110
// http://www.gamerendering.com/2008/10/11/gaussian-blur-filter-shader/
uniform sampler2D in_Texture;
varying vec2 var_TexCoord;
uniform float in_Width;
float blurSize = 1.0/in_Width;

void main()
{

   vec4 sum = vec4(0.0);
   sum += texture2D(in_Texture, vec2(var_TexCoord.x - 4.0*blurSize, var_TexCoord.y)) * 0.05;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x - 3.0*blurSize, var_TexCoord.y)) * 0.09;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x - 2.0*blurSize, var_TexCoord.y)) * 0.12;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x - blurSize, var_TexCoord.y))     * 0.15;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x, var_TexCoord.y))                * 0.165;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x + blurSize, var_TexCoord.y))     * 0.15;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x + 2.0*blurSize, var_TexCoord.y)) * 0.12;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x + 3.0*blurSize, var_TexCoord.y)) * 0.09;
   sum += texture2D(in_Texture, vec2(var_TexCoord.x + 4.0*blurSize, var_TexCoord.y)) * 0.05;
 
   gl_FragColor = sum;
}