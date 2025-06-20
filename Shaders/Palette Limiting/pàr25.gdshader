shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

// Updated color palette
uniform vec4 color_1 = vec4(0.4157, 0.4157, 0.6353, 1.0);  // #692aa2
uniform vec4 color_2 = vec4(0.6078, 0.2353, 0.7059, 1.0);  // #9b3ab4
uniform vec4 color_3 = vec4(0.7922, 0.3137, 0.7647, 1.0);  // #cb4fc4
uniform vec4 color_4 = vec4(0.9490, 0.3333, 0.7569, 1.0);  // #f682c0
uniform vec4 color_5 = vec4(1.0, 0.7843, 0.8824, 1.0);     // #ffc5e4
uniform vec4 color_6 = vec4(0.1843, 0.2824, 0.5412, 1.0);  // #2f488b
uniform vec4 color_7 = vec4(0.1608, 0.6235, 0.6824, 1.0);  // #287fae
uniform vec4 color_8 = vec4(0.2667, 0.6863, 0.8078, 1.0);  // #44afce
uniform vec4 color_9 = vec4(0.4157, 0.8706, 0.9020, 1.0);  // #68dee7
uniform vec4 color_10 = vec4(0.7451, 0.9922, 1.0, 1.0);   // #bdfeff
uniform vec4 color_11 = vec4(0.0824, 0.3529, 0.3529, 1.0); // #155b5d
uniform vec4 color_12 = vec4(0.0667, 0.5882, 0.3843, 1.0); // #178764
uniform vec4 color_13 = vec4(0.1686, 0.7333, 0.4353, 1.0); // #2aba6e
uniform vec4 color_14 = vec4(0.5412, 0.9216, 0.4275, 1.0); // #89ec6b
uniform vec4 color_15 = vec4(0.7529, 0.9922, 0.7059, 1.0); // #bffeb3
uniform vec4 color_16 = vec4(0.5765, 0.0784, 0.4039, 1.0); // #921866
uniform vec4 color_17 = vec4(0.8784, 0.2157, 0.3804, 1.0); // #e23861
uniform vec4 color_18 = vec4(0.9961, 0.4509, 0.2275, 1.0); // #fe7239
uniform vec4 color_19 = vec4(0.9961, 0.8509, 0.2000, 1.0); // #fec033
uniform vec4 color_20 = vec4(0.9961, 0.9490, 0.7098, 1.0); // #fef2b3
uniform vec4 color_21 = vec4(0.2824, 0.2157, 0.2941, 1.0); // #473159
uniform vec4 color_22 = vec4(0.4039, 0.2980, 0.3333, 1.0); // #67616f
uniform vec4 color_23 = vec4(0.5765, 0.5451, 0.5804, 1.0); // #938b98
uniform vec4 color_24 = vec4(0.7686, 0.7647, 0.8235, 1.0); // #c4c5d0
uniform vec4 color_25 = vec4(0.9490, 0.9490, 1.0, 1.0);     // #f4ffff

void fragment() {
    vec4 colors[25] = {color_1, color_2, color_3, color_4, color_5, color_6, color_7, color_8, color_9, color_10,
                       color_11, color_12, color_13, color_14, color_15, color_16, color_17, color_18, color_19, color_20,
                       color_21, color_22, color_23, color_24, color_25};
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