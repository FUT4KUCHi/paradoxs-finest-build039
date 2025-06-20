// Sangria https://lospec.com/palette-list/sangria
shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec4 color_1 = vec4(0.129412, 0.023529, 0.074510, 1.0); // #210613
uniform vec4 color_2 = vec4(0.964706, 0.188235, 0.564706, 1.0); // #f63090
uniform vec4 color_3 = vec4(1.0, 1.0, 0.960784, 1.0);           // #fffff5

void fragment() {
    vec4 colors[3] = {color_1, color_2, color_3};
    vec4 pixel = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);

    float min_difference = 1000.0;
    vec4 min_color = vec4(0.0, 0.0, 0.0, 1.0);

    for (int i = 0; i < colors.length(); i++) {
        float current_distance = distance(colors[i], pixel);
        if (current_distance < min_difference) {
            min_difference = current_distance;
            min_color = colors[i];
        }
    }
    COLOR.rgb = min_color.rgb;
}