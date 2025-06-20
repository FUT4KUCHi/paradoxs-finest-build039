// Cyber-37

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec4 color_1 = vec4(0.164706, 0.121569, 0.258824, 1.0); // #2a1e42
uniform vec4 color_2 = vec4(0.176471, 0.149020, 0.250980, 1.0); // #2d2640
uniform vec4 color_3 = vec4(0.207843, 0.231373, 0.301961, 1.0); // #353b4d
uniform vec4 color_4 = vec4(0.305882, 0.313725, 0.458824, 1.0); // #4e5075
uniform vec4 color_5 = vec4(0.458824, 0.380392, 0.611765, 1.0); // #75619c
uniform vec4 color_6 = vec4(0.635294, 0.517647, 0.741177, 1.0); // #a184bd
uniform vec4 color_7 = vec4(0.682353, 0.611765, 0.839216, 1.0); // #ae9cd6
uniform vec4 color_8 = vec4(0.627451, 0.607843, 0.803922, 1.0); // #a099cc
uniform vec4 color_9 = vec4(0.505882, 0.490196, 0.741177, 1.0); // #817dbd
uniform vec4 color_10 = vec4(0.462745, 0.462745, 0.639215, 1.0); // #7676a3
uniform vec4 color_11 = vec4(0.372549, 0.439216, 0.580392, 1.0); // #5f7094
uniform vec4 color_12 = vec4(0.286275, 0.319608, 0.509804, 1.0); // #495182
uniform vec4 color_13 = vec4(0.203922, 0.192157, 0.401961, 1.0); // #343166
uniform vec4 color_14 = vec4(0.121569, 0.121569, 0.341177, 1.0); // #1f1f57
uniform vec4 color_15 = vec4(0.258824, 0.105882, 0.290196, 1.0); // #421b4a
uniform vec4 color_16 = vec4(0.419608, 0.168627, 0.380392, 1.0); // #6b2b61
uniform vec4 color_17 = vec4(0.529412, 0.188235, 0.309804, 1.0); // #872f4f
uniform vec4 color_18 = vec4(0.658824, 0.160784, 0.160784, 1.0); // #a82828
uniform vec4 color_19 = vec4(0.827451, 0.298039, 0.164706, 1.0); // #d44c2a
uniform vec4 color_20 = vec4(0.851961, 0.537255, 0.298039, 1.0); // #d9894c
uniform vec4 color_21 = vec4(0.870588, 0.654902, 0.427451, 1.0); // #dea76d
uniform vec4 color_22 = vec4(0.909804, 0.850980, 0.600000, 1.0); // #e8d899
uniform vec4 color_23 = vec4(0.941177, 0.960784, 0.784314, 1.0); // #f0f5c7
uniform vec4 color_24 = vec4(0.800000, 0.858824, 0.721569, 1.0); // #ccdbb8
uniform vec4 color_25 = vec4(0.553333, 0.674118, 0.537255, 1.0); // #8dab89
uniform vec4 color_26 = vec4(0.474510, 0.580392, 0.494118, 1.0); // #79947d
uniform vec4 color_27 = vec4(0.439216, 0.501961, 0.466667, 1.0); // #708078
uniform vec4 color_28 = vec4(0.305882, 0.380392, 0.376471, 1.0); // #4e6160
uniform vec4 color_29 = vec4(0.215686, 0.270588, 0.302000, 1.0); // #38464d
uniform vec4 color_30 = vec4(0.172549, 0.207843, 0.266667, 1.0); // #2c3545
uniform vec4 color_31 = vec4(0.211765, 0.227451, 0.368627, 1.0); // #373a5e
uniform vec4 color_32 = vec4(0.325490, 0.321569, 0.501961, 1.0); // #535280
uniform vec4 color_33 = vec4(0.501961, 0.454902, 0.584314, 1.0); // #807594
uniform vec4 color_34 = vec4(0.635294, 0.635294, 0.690196, 1.0); // #a2a2b0
uniform vec4 color_35 = vec4(0.760784, 0.784314, 0.839216, 1.0); // #c3c8d6
uniform vec4 color_36 = vec4(0.874510, 0.898039, 0.960784, 1.0); // #dfe5f5
uniform vec4 color_37 = vec4(0.898039, 0.960784, 1.0, 1.0);      // #e5f5ff

void fragment() {
    vec4 colors[37] = {
        color_1, color_2, color_3, color_4, color_5, color_6, color_7,
        color_8, color_9, color_10, color_11, color_12, color_13, color_14,
        color_15, color_16, color_17, color_18, color_19, color_20, color_21,
        color_22, color_23, color_24, color_25, color_26, color_27, color_28,
        color_29, color_30, color_31, color_32, color_33, color_34, color_35,
        color_36, color_37
    };
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