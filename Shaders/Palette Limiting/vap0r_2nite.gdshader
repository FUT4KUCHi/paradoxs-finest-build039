shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

// Updated color palette
uniform vec4 color_1 = vec4(0.9804, 0.7843, 0.9373, 1.0);  // #f9caef
uniform vec4 color_2 = vec4(0.9647, 0.7059, 1.0, 1.0);     // #f6b4ff
uniform vec4 color_3 = vec4(0.9922, 0.5176, 0.9804, 1.0);  // #fd84f9
uniform vec4 color_4 = vec4(0.2353, 0.1725, 0.7843, 1.0);  // #3c2cc9
uniform vec4 color_5 = vec4(0.0392, 0.2706, 0.7451, 1.0);  // #0a4bff
uniform vec4 color_6 = vec4(0.3765, 0.3765, 0.9373, 1.0);  // #6061ef
uniform vec4 color_7 = vec4(0.6235, 0.4275, 0.7451, 1.0);  // #a29bff
uniform vec4 color_8 = vec4(0.4471, 0.9490, 0.8902, 1.0);  // #72f8e3
uniform vec4 color_9 = vec4(0.6353, 0.9608, 1.0, 1.0);     // #a3f9ff
uniform vec4 color_10 = vec4(0.9333, 1.0, 0.6392, 1.0);    // #eeffa3

void fragment() {
    vec4 colors[10] = {color_1, color_2, color_3, color_4, color_5, color_6, color_7, color_8, color_9, color_10};
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
