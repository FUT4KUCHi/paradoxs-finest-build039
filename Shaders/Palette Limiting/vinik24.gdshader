shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

// Updated color palette
uniform vec4 color_1 = vec4(0.0, 0.0, 0.0, 1.0);  // #000000
uniform vec4 color_2 = vec4(0.4392, 0.4078, 0.4549, 1.0);  // #6f6776
uniform vec4 color_3 = vec4(0.6039, 0.6039, 0.5922, 1.0);  // #9a9a97
uniform vec4 color_4 = vec4(0.7843, 0.8000, 0.7216, 1.0);  // #c5ccb8
uniform vec4 color_5 = vec4(0.5451, 0.3333, 0.4980, 1.0);  // #8b5580
uniform vec4 color_6 = vec4(0.7686, 0.5529, 0.5608, 1.0);  // #c38890
uniform vec4 color_7 = vec4(0.6431, 0.5882, 0.6471, 1.0);  // #a593a5
uniform vec4 color_8 = vec4(0.4078, 0.2980, 0.5686, 1.0);  // #666092
uniform vec4 color_9 = vec4(0.6039, 0.3098, 0.3137, 1.0);  // #9a4f50
uniform vec4 color_10 = vec4(0.7647, 0.5529, 0.4627, 1.0); // #c28d75
uniform vec4 color_11 = vec4(0.4863, 0.6353, 0.7843, 1.0); // #7ca1c0
uniform vec4 color_12 = vec4(0.2549, 0.4078, 0.6353, 1.0); // #416aa3
uniform vec4 color_13 = vec4(0.5569, 0.3882, 0.4196, 1.0); // #8d6268
uniform vec4 color_14 = vec4(0.7451, 0.5882, 0.3529, 1.0); // #be955c
uniform vec4 color_15 = vec4(0.4157, 0.6706, 0.6509, 1.0); // #68aca9
uniform vec4 color_16 = vec4(0.2235, 0.2941, 0.5010, 1.0); // #387080
uniform vec4 color_17 = vec4(0.4353, 0.4157, 0.3843, 1.0); // #6e6962
uniform vec4 color_18 = vec4(0.5765, 0.6235, 0.4039, 1.0); // #93a167
uniform vec4 color_19 = vec4(0.4353, 0.6706, 0.4784, 1.0); // #6eaa78
uniform vec4 color_20 = vec4(0.3333, 0.4078, 0.3922, 1.0); // #557064
uniform vec4 color_21 = vec4(0.6157, 0.6235, 0.4980, 1.0); // #9d9f7f
uniform vec4 color_22 = vec4(0.4941, 0.6157, 0.6078, 1.0); // #7e9e99
uniform vec4 color_23 = vec4(0.3686, 0.4157, 0.4509, 1.0); // #5d6872
uniform vec4 color_24 = vec4(0.2588, 0.2157, 0.3333, 1.0); // #433455

void fragment() {
    vec4 colors[24] = {color_1, color_2, color_3, color_4, color_5, color_6, color_7, color_8, color_9, color_10,
                       color_11, color_12, color_13, color_14, color_15, color_16, color_17, color_18, color_19, color_20,
                       color_21, color_22, color_23, color_24};
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