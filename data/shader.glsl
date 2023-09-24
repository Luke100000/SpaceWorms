uniform vec4 COLOR_0;
uniform vec4 COLOR_1;
uniform vec4 COLOR_2;
uniform vec4 COLOR_3;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
    vec4 c = Texel(tex, tc);

	if (c.r > 0.99) {
		return COLOR_3;
	} else if (c.r > 0.5) {
		return COLOR_2;
	} else if (c.r > 0.01) {
		return COLOR_1;
	} else {
		return COLOR_0;
	}
}