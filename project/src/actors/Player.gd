extends Area

#var speed = 0.1
var target_location:Vector3 = Vector3(0,0,0)
export var movement_range = Vector2(0,0)
export var base_lerp = 2 #2.5
export var boost_lerp = 2.5

var boosted:bool = false
var boost_disabled = true

func _ready():
	pass
	

func _physics_process(delta):
	#pass
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT||BUTTON_RIGHT) and not boost_disabled:
		boosted = true
	else:
		boosted = false
	
	if target_location.x<=movement_range.x : target_location.x=movement_range.x
	if target_location.x>=movement_range.y : target_location.x=movement_range.y
	
	if global_transform.origin != target_location:
		#look_at(target_location, Vector3.UP)
		#transform.origin += (transform.origin.direction_to(target_location)*speed)*delta
		if boosted==false:
			transform.origin = transform.origin.linear_interpolate(target_location, base_lerp*delta)
		else:
			transform.origin = transform.origin.linear_interpolate(target_location, boost_lerp*delta)
		transform.origin.y = 0;
	if global_transform.origin.x<=movement_range.x : global_transform.origin.x=movement_range.x
	if global_transform.origin.x>=movement_range.y : global_transform.origin.x=movement_range.y
	print (global_transform.origin.x)


func _on_Player_area_entered(area):
	if area.is_in_group("plant"):
		#play feedback sound
		if area.has_method("handle_collision"):
			area.call("handle_collision")
	if area.is_in_group("obstacle"):
		if area.has_method("handle_collision"):
			area.call("handle_collision")
			Events.emit_signal("hit_rock")
		
		
		
