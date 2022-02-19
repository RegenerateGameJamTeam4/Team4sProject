extends Area

var speed = 0.1
var target_location:Vector3 = Vector3(0,0,0)

func _ready():
	pass
	

func _physics_process(delta):
	#pass
	if global_transform.origin != target_location:
		look_at(target_location, Vector3.UP)
		#transform.origin += (transform.origin.direction_to(target_location)*speed)*delta
		transform.origin = transform.origin.linear_interpolate(target_location, 0.35*delta)
		transform.origin.y = 0;

