extends MeshInstance

export var scroll_speed:Vector3 = Vector3(0,0,0)
var material

func _ready():
	#material = get_surface_material(0) as ShaderMaterial
	get_surface_material(0).set_shader_param("uv_scroll", Vector2(0,-(Global.speed/10.0)))

func _process(delta):
	pass
	#get_surface_material(0).uv1_offset.y += -(Global.speed/10.0) * delta
	
