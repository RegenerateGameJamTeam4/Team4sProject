extends Spatial

export var scroll_direction:Vector2
export var uv_offset:Vector2
export var mesh_size:Vector2

func _ready():
	#material = get_surface_material(0) as ShaderMaterial
	$Mesh.get_surface_material(0).set_shader_param("uv_scroll", Vector2(0,-(Global.speed/10.0)))
	$Mesh.get_surface_material(0).set_shader_param("uv_offset", uv_offset)

func _process(delta):
	if get_tree().paused:
		$Mesh.get_surface_material(0).set_shader_param("uv_scroll", Vector2(0,0))
	else:
		$Mesh.get_surface_material(0).set_shader_param("uv_scroll", Vector2(scroll_direction.x * (Global.speed/mesh_size.x),scroll_direction.y * (Global.speed/mesh_size.y)))
	
