// Leftover Salad https://lospec.com/palette-list/leftover-salad

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec4 color_1 = vec4(0.713725, 0.756863, 0.654902, 1.0); // #b6c1a7
uniform vec4 color_2 = vec4(0.701961, 0.588235, 0.443137, 1.0); // #b39671
uniform vec4 color_3 = vec4(0.592157, 0.631373, 0.352941, 1.0); // #97a15a
uniform vec4 color_4 = vec4(0.466667, 0.643137, 0.517647, 1.0); // #77a484
uniform vec4 color_5 = vec4(0.654902, 0.580392, 0.651961, 1.0); // #a594a5
uniform vec4 color_6 = vec4(0.564706, 0.482353, 0.196078, 1.0); // #907b32
uniform vec4 color_7 = vec4(0.325490, 0.506667, 0.406667, 1.0); // #528168
uniform vec4 color_8 = vec4(0.6, 0.415686, 0.462745, 1.0);      // #996a76
uniform vec4 color_9 = vec4(0.403922, 0.478431, 0.556863, 1.0); // #67798e
uniform vec4 color_10 = vec4(0.321569, 0.352941, 0.231373, 1.0); // #525a3b
uniform vec4 color_11 = vec4(0.203922, 0.360784, 0.388235, 1.0); // #365c63
uniform vec4 color_12 = vec4(0.164706, 0.223529, 0.168627, 1.0); // #2a382b

void fragment() {
    vec4 colors[12] = {
        color_1, color_2, color_3, color_4, color_5, color_6, color_7,
        color_8, color_9, color_10, color_11, color_12
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