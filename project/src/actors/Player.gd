extends Area

var speed = 5
var target_location:Vector3 = Vector3(0,0,0)

func _ready():
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	pass
	#if global_transform.origin != target_location:
		#look_at(target_location, Vector3.UP)
		#transform.origin.z+= speed*delta
