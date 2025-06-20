shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

// Updated color palette
uniform vec4 color_1 = vec4(1.0, 0.6549, 0.8471, 1.0);  // #ffa6d9
uniform vec4 color_2 = vec4(0.8039, 0.5451, 0.7059, 1.0);  // #cd89b3
uniform vec4 color_3 = vec4(0.5647, 0.4039, 0.5176, 1.0);  // #8f6684
uniform vec4 color_4 = vec4(0.2784, 0.2392, 0.3020, 1.0);  // #473d4e
uniform vec4 color_5 = vec4(0.1098, 0.1451, 0.1725, 1.0);  // #1c252d
uniform vec4 color_6 = vec4(0.0314, 0.1098, 0.1176, 1.0);  // #08191e

void fragment() {
    vec4 colors[6] = {color_1, color_2, color_3, color_4, color_5, color_6};
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
    COLOR = min_color;
}
