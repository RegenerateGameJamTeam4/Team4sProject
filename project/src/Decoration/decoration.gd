extends Spatial

func _physics_process(delta):
	global_transform.origin.z += Global.speed * delta
