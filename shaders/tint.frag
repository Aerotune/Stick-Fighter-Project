#version 110

uniform sampler2D in_Texture; // Original in_Texture.
varying vec2 var_TexCoord; // Pixel to process on this pass

uniform vec3 in_Color;

void main()
{
    vec4 base_color = texture2D(in_Texture, var_TexCoord);
    base_color[0] = in_Color[0];
    base_color[1] = in_Color[1];
    base_color[2] = in_Color[2];
    gl_FragColor = base_color;
}