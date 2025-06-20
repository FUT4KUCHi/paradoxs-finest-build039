shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

// Updated color palette.

uniform vec4 color_1 = vec4(1.0, 1.0, 1.0, 1.0);          // #ffffff
uniform vec4 color_2 = vec4(0.047059, 0.901961, 0.94902, 1.0);  // #0ce6f2
uniform vec4 color_3 = vec4(0.0, 0.596078, 0.858824, 1.0);      // #0098db
uniform vec4 color_4 = vec4(0.117647, 0.341176, 0.611765, 1.0); // #1e579c
uniform vec4 color_5 = vec4(0.12549, 0.207843, 0.384314, 1.0);  // #203562
uniform vec4 color_6 = vec4(0.145098, 0.141176, 0.27451, 1.0);  // #252446
uniform vec4 color_7 = vec4(0.12549, 0.078431, 0.2, 1.0);       // #201533

void fragment() {
    vec4 colors[7] = {color_1, color_2, color_3, color_4, color_5, color_6, color_7};
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