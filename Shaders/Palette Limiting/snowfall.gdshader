shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

// Updated color palette
uniform vec4 color_1 = vec4(0.2471, 0.2196, 0.3529, 1.0);  // #3f375d
uniform vec4 color_2 = vec4(0.2941, 0.3137, 0.4824, 1.0);  // #4b517b
uniform vec4 color_3 = vec4(0.3922, 0.5333, 0.7098, 1.0);  // #6389b5
uniform vec4 color_4 = vec4(0.6588, 0.7451, 0.8706, 1.0);  // #a8bede
uniform vec4 color_5 = vec4(0.8627, 0.7843, 0.8902, 1.0);  // #ddc8e3
uniform vec4 color_6 = vec4(0.7451, 0.5804, 0.7765, 1.0);  // #bf98c5
uniform vec4 color_7 = vec4(0.5098, 0.2431, 0.5216, 1.0);  // #836089
uniform vec4 color_8 = vec4(0.4157, 0.2941, 0.4549, 1.0);  // #694970
uniform vec4 color_9 = vec4(0.2353, 0.1412, 0.2431, 1.0);  // #3b243e
uniform vec4 color_10 = vec4(0.4275, 0.1176, 0.2706, 1.0); // #6d1945
uniform vec4 color_11 = vec4(0.7843, 0.3020, 0.4431, 1.0); // #c54d71
uniform vec4 color_12 = vec4(0.8980, 0.5294, 0.3725, 1.0); // #e48a5f
uniform vec4 color_13 = vec4(0.9490, 0.7451, 0.6039, 1.0); // #f2bf99
uniform vec4 color_14 = vec4(0.9686, 0.9176, 0.7696, 1.0); // #f7e9c4
uniform vec4 color_15 = vec4(0.8196, 0.7922, 0.6275, 1.0); // #d1cba0
uniform vec4 color_16 = vec4(0.6275, 0.6706, 0.5451, 1.0); // #a1ad8c
uniform vec4 color_17 = vec4(0.5412, 0.5529, 0.2980, 1.0); // #8a8c4c
uniform vec4 color_18 = vec4(0.4824, 0.4157, 0.1922, 1.0); // #7b6d31
uniform vec4 color_19 = vec4(0.2824, 0.2275, 0.1804, 1.0); // #483a2e

void fragment() {
    vec4 colors[19] = {color_1, color_2, color_3, color_4, color_5, color_6, color_7, color_8, color_9, color_10,
                       color_11, color_12, color_13, color_14, color_15, color_16, color_17, color_18, color_19};
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