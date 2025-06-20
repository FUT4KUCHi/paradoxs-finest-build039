shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

// Updated color palette
uniform vec4 color_1 = vec4(0.8196, 0.6941, 0.5294, 1.0);  // #d1b187
uniform vec4 color_2 = vec4(0.7804, 0.4824, 0.3451, 1.0);  // #c77b58
uniform vec4 color_3 = vec4(0.6824, 0.3647, 0.2510, 1.0);  // #ae5d40
uniform vec4 color_4 = vec4(0.4745, 0.2667, 0.2902, 1.0);  // #79444a
uniform vec4 color_5 = vec4(0.2941, 0.2392, 0.2667, 1.0);  // #4b3d44
uniform vec4 color_6 = vec4(0.7294, 0.5686, 0.3451, 1.0);  // #ba9158
uniform vec4 color_7 = vec4(0.5725, 0.4549, 0.2549, 1.0);  // #927441
uniform vec4 color_8 = vec4(0.3020, 0.2706, 0.2235, 1.0);  // #4d4539
uniform vec4 color_9 = vec4(0.4667, 0.4549, 0.2314, 1.0);  // #77743b
uniform vec4 color_10 = vec4(0.7020, 0.6471, 0.3333, 1.0); // #b3a555
uniform vec4 color_11 = vec4(0.8235, 0.7882, 0.6471, 1.0); // #d2c9a5
uniform vec4 color_12 = vec4(0.5490, 0.6706, 0.6314, 1.0); // #8caba1
uniform vec4 color_13 = vec4(0.2941, 0.4471, 0.4314, 1.0); // #4b726e
uniform vec4 color_14 = vec4(0.3412, 0.2824, 0.3216, 1.0); // #574852
uniform vec4 color_15 = vec4(0.5176, 0.4706, 0.4588, 1.0); // #847875
uniform vec4 color_16 = vec4(0.6706, 0.6078, 0.5569, 1.0); // #ab9b8e

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