shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

// Updated color palette.

uniform vec4 color_1 = vec4(0.121569, 0.141176, 0.039216, 1.0);  // #1f240a
uniform vec4 color_2 = vec4(0.223529, 0.341176, 0.109804, 1.0);  // #39571c
uniform vec4 color_3 = vec4(0.647059, 0.54902, 0.152941, 1.0);   // #a58c27
uniform vec4 color_4 = vec4(0.937255, 0.67451, 0.156863, 1.0);   // #efac28
uniform vec4 color_5 = vec4(0.937255, 0.847059, 0.631373, 1.0);  // #efd8a1
uniform vec4 color_6 = vec4(0.670588, 0.360784, 0.109804, 1.0);  // #ab5c1c
uniform vec4 color_7 = vec4(0.094118, 0.247059, 0.223529, 1.0);  // #183f39
uniform vec4 color_8 = vec4(0.937255, 0.411765, 0.184314, 1.0);  // #ef692f
uniform vec4 color_9 = vec4(0.937255, 0.717647, 0.458824, 1.0);  // #efb775
uniform vec4 color_10 = vec4(0.647059, 0.384314, 0.262745, 1.0); // #a56243
uniform vec4 color_11 = vec4(0.466667, 0.203922, 0.129412, 1.0); // #773421
uniform vec4 color_12 = vec4(0.447059, 0.254902, 0.07451, 1.0);  // #724113
uniform vec4 color_13 = vec4(0.164706, 0.113725, 0.05098, 1.0);  // #2a1d0d
uniform vec4 color_14 = vec4(0.223529, 0.164706, 0.109804, 1.0); // #392a1c
uniform vec4 color_15 = vec4(0.407843, 0.298039, 0.235294, 1.0); // #684c3c
uniform vec4 color_16 = vec4(0.572549, 0.494118, 0.415686, 1.0); // #927e6a
uniform vec4 color_17 = vec4(0.152941, 0.392157, 0.407843, 1.0); // #276468
uniform vec4 color_18 = vec4(0.937255, 0.227451, 0.047059, 1.0); // #ef3a0c
uniform vec4 color_19 = vec4(0.270588, 0.137255, 0.05098, 1.0);  // #45230d
uniform vec4 color_20 = vec4(0.235294, 0.623529, 0.611765, 1.0); // #3c9f9c
uniform vec4 color_21 = vec4(0.607843, 0.101961, 0.039216, 1.0); // #9b1a0a
uniform vec4 color_22 = vec4(0.211765, 0.090196, 0.047059, 1.0); // #36170c
uniform vec4 color_23 = vec4(0.333333, 0.058824, 0.039216, 1.0); // #550f0a
uniform vec4 color_24 = vec4(0.188235, 0.058824, 0.039216, 1.0); // #300f0a

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
