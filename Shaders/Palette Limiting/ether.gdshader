// Ether https://lospec.com/palette-list/ether

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec4 color_1 = vec4(0.988235, 0.956863, 1.0, 1.0); // #fbf4ff
uniform vec4 color_2 = vec4(0.721569, 0.878431, 0.992157, 1.0); // #b8defd
uniform vec4 color_3 = vec4(0.113725, 0.819608, 0.784314, 1.0); // #1cd1c8

void fragment() {
    vec4 colors[3] = {color_1, color_2, color_3};
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