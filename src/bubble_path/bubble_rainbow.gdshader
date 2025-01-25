shader_type spatial;

uniform sampler2D noise_tex;
uniform float spikiness;
uniform float speed;
uniform vec3 color;

float fresnel(vec3 normal, mat4 camera_matrix){
	vec3 view_direction_world = (camera_matrix * vec4(0.0,0.0,1.0,0.0)).xyz;
	vec3 normal_world = (camera_matrix * vec4(normal,0.0)).xyz;

	float d = dot(view_direction_world, normal_world);
	d = abs(d);
	d = clamp(d, 0.0, 1.0);

	return 1.0 - d;
}

void vertex() {
	float height = texture(noise_tex, VERTEX.xz * spikiness + vec2(TIME)*speed).r;
	VERTEX += NORMAL * height * 0.5;
}

float hue2rgb(float f1, float f2, float hue) {
    if (hue < 0.0)
        hue += 1.0;
    else if (hue > 1.0)
        hue -= 1.0;
    float res;
    if ((6.0 * hue) < 1.0)
        res = f1 + (f2 - f1) * 6.0 * hue;
    else if ((2.0 * hue) < 1.0)
        res = f2;
    else if ((3.0 * hue) < 2.0)
        res = f1 + (f2 - f1) * ((2.0 / 3.0) - hue) * 6.0;
    else
        res = f1;
    return res;
}

vec3 hsl2rgb(vec3 hsl) {
    vec3 rgb;

    if (hsl.y == 0.0) {
        rgb = vec3(hsl.z); // Luminance
    } else {
        float f2;

        if (hsl.z < 0.5)
            f2 = hsl.z * (1.0 + hsl.y);
        else
            f2 = hsl.z + hsl.y - hsl.y * hsl.z;

        float f1 = 2.0 * hsl.z - f2;

        rgb.r = hue2rgb(f1, f2, hsl.x + (1.0/3.0));
        rgb.g = hue2rgb(f1, f2, hsl.x);
        rgb.b = hue2rgb(f1, f2, hsl.x - (1.0/3.0));
    }
    return rgb;
}

void fragment() {
	ALPHA = fresnel(NORMAL, VIEW_MATRIX);
	ROUGHNESS = 1.5;

	float a = atan(VERTEX.y, VERTEX.x) / TAU;

	// vec3 col = hsl2rgb(vec3(a, 1.0, 0.5));
	vec3 col = color;

	ALBEDO = col;
}
