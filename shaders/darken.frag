#version 110
// http://www.gamerendering.com/2008/10/11/gaussian-blur-filter-shader/
uniform sampler2D in_Texture; // Original in_Texture.
varying vec2 var_TexCoord; // Pixel to process on this pass

void main()
{
	gl_FragColor = texture2D(in_Texture, var_TexCoord) - vec4(0.6, 0.6, 0.8, 0.0);
}