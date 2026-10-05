shader_type spatial;
uniform float height_scale = 0.25;
uniform sampler2D noise;
uniform sampler2D albedo;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

varying vec2 vertex_position;


float wave(vec2 position){
  position += texture(noise, position / 64.0).x * 2.0 - 1.0;
  vec2 wv = 1.0 - abs(sin(position));
  return pow(1.0 - pow(wv.x * wv.y, 0.65), 4.0);
}

float height(vec2 position, float time) {
  float d = wave((position + time) * 0.4) * 0.3;
  d += wave((position - time) * 0.3) * 0.3;
  d += wave((position + time) * 0.5) * 0.2;
  d += wave((position - time) * 0.6) * 0.2;
  return d;
}

void vertex() {
  vec2 pos = VERTEX.xz;
  float k = height(pos, TIME);
  VERTEX.y = k;
  NORMAL = normalize(vec3(k - height(pos + vec2(0.1, 0.0), TIME), 0.1, k - height(pos + vec2(0.0, 0.1), TIME)));
  UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(albedo,base_uv);
	ALBEDO = albedo_tex.rgb;
	ROUGHNESS = 1.0;

}
