shader_type spatial;

uniform vec4 primary_color : source_color;
uniform vec4 secondary_color : source_color;

uniform sampler2D normalmap_a : hint_normal;
uniform sampler2D normalmap_b : hint_normal;
uniform float roughness : hint_range(0.0, 1.0, 0.1) = 0.2;
uniform float normalmap_a_pow : hint_range(0.0, 1.0, 0.01) = 0.3;
uniform float normalmap_b_pow : hint_range(0.0, 1.0, 0.01) = 0.2;
uniform vec2 wave_direction = vec2(0.1,0.1);
uniform float wave_speed = 0.2;
uniform float uv_scale=1.0;

uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float depth_distance : hint_range(0.0, 20.0, 0.1) = 4.0;
uniform float beers_law : hint_range(0.0, 20.0, 0.1) = 12.0;
uniform float water_transparency : hint_range(0.0, 1.0, 0.05)= 0.1;

uniform float refraction_strength : hint_range(0.0, 1.0, 0.05) = 0.5;



void fragment()
	{
		vec2 uv = UV*uv_scale;
		vec2 uv_move = wave_direction*wave_speed*TIME;
		
		//normal normalmaps
		vec3 normalmap = texture(normalmap_a,uv+uv_move).rgb*normalmap_a_pow;
		normalmap += texture(normalmap_b,uv-uv_move).rgb*normalmap_b_pow;
		
		//sample normalmaps to get refractionmaps
		vec3 ref_normalmap = normalmap * 2.0 - (normalmap_a_pow+normalmap_b_pow);
		vec3 ref_normal = mix(NORMAL,ref_normalmap*(TANGENT+NORMAL+BINORMAL),1.0);
		vec2 ref_ofs = SCREEN_UV - ref_normal.xy * refraction_strength * 0.1;
		
		//get depth and screen textures
		float depth_clean = textureLod(depth_texture, SCREEN_UV, 0.0).r;
		float depth = textureLod(depth_texture, ref_ofs, 0.0).r;
		vec3 screen = textureLod(screen_texture, ref_ofs, 0.0).rgb;
		
		//get depth in world position
		vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
		vec3 ndc_clean = vec3(SCREEN_UV * 2.0 - 1.0, depth_clean);
		
		//get depth in view matrix
		vec4 view = INV_PROJECTION_MATRIX * vec4(ndc,1.0);
		view.xyz/=view.w;
		float linear_depth = -view.z + VERTEX.z;
		
		vec4 world;
		
		if (linear_depth<0.00001){
			world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(ndc_clean,1.0);
		}else{
			world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(ndc,1.0);
		}
		
		float depth_texture_y = world.y/world.w;
		float vertex_y = (INV_VIEW_MATRIX * vec4(VERTEX,1.0)).y;
		
		//set blend depth and adjust beer's law
		float depth_blend = clamp((vertex_y-depth_texture_y)/depth_distance,0.0,1.0);
		depth_blend = exp(-depth_blend*beers_law);
		
		vec4 depth_color = mix(secondary_color,primary_color,depth_blend);
		vec3 refraction_texture = textureLod(screen_texture,ref_ofs,roughness).rgb;
		vec3 final_color = mix(depth_color.rgb, refraction_texture, water_transparency*depth_color.a);
		
		ALBEDO = final_color;
		ROUGHNESS = roughness;
		NORMAL_MAP = normalmap;
	}
	
