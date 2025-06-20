shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

// Updated color palette
uniform vec4 color_1 = vec4(0.0049, 0.0529, 0.1020, 1.0);  // #010d1a
uniform vec4 color_2 = vec4(0.2824, 0.1647, 0.2157, 1.0);  // #482a37
uniform vec4 color_3 = vec4(0.0941, 0.1873, 0.3804, 1.0);  // #162f62
uniform vec4 color_4 = vec4(0.3647, 0.1608, 0.3529, 1.0);  // #5d285a
uniform vec4 color_5 = vec4(0.0902, 0.2157, 0.2509, 1.0);  // #195740
uniform vec4 color_6 = vec4(0.6759, 0.1608, 0.2549, 1.0);  // #af2841
uniform vec4 color_7 = vec4(0.6039, 0.3529, 0.3294, 1.0);  // #9a5854
uniform vec4 color_8 = vec4(0.2078, 0.5882, 0.8196, 1.0);  // #357bd8
uniform vec4 color_9 = vec4(0.5333, 0.5333, 0.5176, 1.0);  // #888283
uniform vec4 color_10 = vec4(0.2578, 0.6706, 0.4471, 1.0); // #43ab72
uniform vec4 color_11 = vec4(0.9490, 0.4902, 0.3373, 1.0); // #f78057
uniform vec4 color_12 = vec4(0.5098, 0.7647, 0.8235, 1.0); // #83c3d4
uniform vec4 color_13 = vec4(0.9922, 0.7098, 0.5725, 1.0); // #fdb193
uniform vec4 color_14 = vec4(0.7647, 0.8706, 0.3529, 1.0); // #c2e059
uniform vec4 color_15 = vec4(1.0, 0.8549, 0.3373, 1.0);   // #ffda57
uniform vec4 color_16 = vec4(1.0, 0.9529, 0.9333, 1.0);   // #fff3ee

void fragment() {
    vec4 colors[16] = {color_1, color_2, color_3, color_4, color_5, color_6, color_7, color_8, color_9, color_10,
                       color_11, color_12, color_13, color_14, color_15, color_16};
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