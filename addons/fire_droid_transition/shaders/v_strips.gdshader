shader_type canvas_item;

uniform float strips_width = 20.0;
uniform float ratio: hint_range(0.0, 1.0) = 0.5;
uniform vec4 color_1: source_color = vec4(1.0);
uniform vec4 color_2: source_color = vec4(0., 0., 0., 1.0);

void fragment() {
	vec2 tiled_uv = vec2(fract(UV.x * strips_width / 2.0), UV.y);
	if (tiled_uv.x < 0.5){
		if(tiled_uv.y < ratio){
			COLOR = color_1;
		} else {
			COLOR = vec4(0.0);
		}
	}
	else {
		if (tiled_uv.y > 1.0 - ratio){
			COLOR = color_2;
		} else {
			COLOR = vec4(0.0);
		}
	}
}