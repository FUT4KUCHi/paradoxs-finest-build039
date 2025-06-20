// SLS08 https://lospec.com/palette-list/slso8

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec4 color_1 = vec4(0.050980392156862744, 0.16862745098039217, 0.27058823529411763, 1);

uniform vec4 color_2 = vec4(0.12549019607843137, 0.23529411764705882, 0.33725490196078434, 1);

uniform vec4 color_3 = vec4(0.32941176470588235, 0.3058823529411765, 0.40784313725490196, 1);

uniform vec4 color_4 = vec4(0.5529411764705883, 0.4117647058823529, 0.47843137254901963, 1);

uniform vec4 color_5 = vec4(0.8156862745098039, 0.5058823529411764, 0.34901960784313724, 1);

uniform vec4 color_6 = vec4(1, 0.6666666666666666, 0.3686274509803922, 1);

uniform vec4 color_7 = vec4(1, 0.8313725490196079, 0.6392156862745098, 1);

uniform vec4 color_8 = vec4(1, 0.9254901960784314, 0.8392156862745098,1);
void vertex() {

}

void fragment() {
	vec4 colors[8] = {color_1, color_2, color_3, color_4, color_5, color_6, color_7, color_8};
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