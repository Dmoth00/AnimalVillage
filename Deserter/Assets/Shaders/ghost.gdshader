shader_type spatial;
render_mode blend_mix,depth_draw_always,cull_back,diffuse_lambert,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color;
uniform float specular : hint_range(0,1);
uniform float metallic : hint_range(0,1);
uniform float roughness : hint_range(0,1);
uniform float alpha : hint_range(0,1);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;


void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	ALPHA = alpha;
}
