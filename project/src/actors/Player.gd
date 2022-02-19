extends Area

#var speed = 0.1
var target_location:Vector3 = Vector3(0,0,0)
export var base_lerp = 0.45
export var boost_lerp = 0.95

var boosted:bool = false

func _ready():
	pass
	

func _physics_process(delta):
	#pass
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT||BUTTON_RIGHT):
		boosted = true
	else:
		boosted = false
	
	if global_transform.origin != target_location:
		#look_at(target_location, Vector3.UP)
		#transform.origin += (transform.origin.direction_to(target_location)*speed)*delta
		if boosted==false:
			transform.origin = transform.origin.linear_interpolate(target_location, base_lerp*delta)
		else:
			transform.origin = transform.origin.linear_interpolate(target_location, boost_lerp*delta)
		transform.origin.y = 0;
	if global_transform.origin.x<=-0.52 : global_transform.origin.x=-0.52
	if global_transform.origin.x>=0.52 : global_transform.origin.x=0.52
	print (global_transform.origin.x)


func _on_Player_area_entered(area):
	if area.is_in_group("plant"):
		#play feedback sound
		if area.has_method("handle_collision"):
			area.call("handle_collision")
		
		
		
