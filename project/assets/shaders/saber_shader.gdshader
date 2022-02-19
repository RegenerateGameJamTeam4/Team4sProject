// NOTE: Shader automatically converted from Godot Engine 3.4.stable's SpatialMaterial.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,unshaded;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
varying vec3 uv1_triplanar_pos;
uniform float uv1_blend_sharpness;
varying vec3 uv1_power_normal;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform vec3 uv1_scroll;
uniform vec2 tex_clamp;
uniform vec2 fresnel_clamp;
uniform float emission_strength = 3.0;
uniform float flicker_speed = 8.0;
uniform float min_brightness = 0.5;
uniform float displacement_scale = 0.015;

vec4 triplanar_texture(sampler2D p_sampler,vec3 p_weights,vec3 p_triplanar_pos) {
	vec4 samp=vec4(0.0);
	samp+= texture(p_sampler,p_triplanar_pos.xy) * p_weights.z;
	samp+= texture(p_sampler,p_triplanar_pos.xz) * p_weights.y;
	samp+= texture(p_sampler,p_triplanar_pos.zy * vec2(-1.0,1.0)) * p_weights.x;
	return samp;
}

void vertex() {
	TANGENT = vec3(0.0,0.0,-1.0) * abs(NORMAL.x);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(NORMAL.y);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(NORMAL.z);
	TANGENT = normalize(TANGENT);
	BINORMAL = vec3(0.0,1.0,0.0) * abs(NORMAL.x);
	BINORMAL+= vec3(0.0,0.0,-1.0) * abs(NORMAL.y);
	BINORMAL+= vec3(0.0,1.0,0.0) * abs(NORMAL.z);
	BINORMAL = normalize(BINORMAL);
	uv1_power_normal=pow(abs(NORMAL),vec3(uv1_blend_sharpness));
	uv1_power_normal/=dot(uv1_power_normal,vec3(1.0));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset + (uv1_scroll*TIME);
	uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);

	vec4 noise = triplanar_texture(texture_albedo,uv1_power_normal,uv1_triplanar_pos);
	VERTEX = VERTEX + ((noise.xyz-0.5) * NORMAL * displacement_scale);
}

void fragment() {
	vec4 albedo_tex = triplanar_texture(texture_albedo,uv1_power_normal,uv1_triplanar_pos);
	
	vec3 rd = VIEW;

	float n_in2p3 = 1.00;
	float fresnel = smoothstep(fresnel_clamp.x,fresnel_clamp.y,pow(1.0 - clamp(dot(rd, NORMAL), 0.0, 1.0), n_in2p3));
	
	float final_tex = smoothstep(tex_clamp.x,tex_clamp.y, albedo_tex.r);
	float final_emission = min_brightness + emission_strength*abs(cos(TIME*flicker_speed));
	ALBEDO = albedo.rgb * fresnel * final_tex  * final_emission + (albedo.rgb*min_brightness);
}