uniform Image water;
uniform Image lava;
uniform Image schmiamand;
uniform vec2 animation;
uniform vec2 waterScale;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
    vec4 c = Texel(tex, tc);

	if (c.g > 0.5 && c.b > 0.5) {
		vec4 w = Texel(schmiamand, mod((animation * 4.0 + tc) * waterScale, 1.0));
		return vec4(w.r, 0.0, 0.0, 1.0);
	} else if (c.g > 0.5)  {
		vec4 w = Texel(water, mod((animation + tc) * waterScale, 0.5));
		return vec4(w.r, 0.0, 0.0, 1.0);
	} else if (c.b > 0.5)  {
		vec4 w = Texel(lava, mod((animation + tc) * waterScale, 0.5));
		return vec4(w.r, 0.0, 0.0, 1.0);
	} else {
		return vec4(c.r, 0.0, 0.0, c.a);
	}
}