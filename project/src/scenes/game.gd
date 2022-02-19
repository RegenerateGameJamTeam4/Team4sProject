extends Spatial

export var camera_stickiness = 0.15

#references
onready var camera = $Camera
onready var player = $Player


func _ready():
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	#camera.translation = camera.translation.linear_interpolate(player.translation, camera_stickiness)
	var mouse_pos = get_viewport().get_mouse_position()
	
	var space_state = get_world().direct_space_state
	
	var raycast = space_state.intersect_ray(camera.project_ray_origin(mouse_pos),
							 camera.project_ray_normal(mouse_pos))
	
	var dropPlane  = Plane(Vector3(0, 0, 1), -0.5)
	var raycast_pos = dropPlane.intersects_ray(
							 camera.project_ray_origin(mouse_pos),
							 camera.project_ray_normal(mouse_pos))
	if raycast_pos:
		$target_cursor.global_transform.origin = raycast_pos
		player.target_location = $target_cursor.global_transform.origin
