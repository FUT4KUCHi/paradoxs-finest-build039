// Obsidian https://lospec.com/palette-list/obsidian

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec4 color_1 = vec4(0.572549, 0.129411, 0.372549, 1.0); // #92215f
uniform vec4 color_2 = vec4(0.349019, 0.047058, 0.407843, 1.0); // #590c68
uniform vec4 color_3 = vec4(0.0, 0.031372, 0.156862, 1.0);      // #000828

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