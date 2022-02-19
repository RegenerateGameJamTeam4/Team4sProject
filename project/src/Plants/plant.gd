extends Area

class_name Plant

export(String, "tree", "shrub", "vegetable") var type = ""
export var sugar_value:float
export var nutrient_value:float
export var community_value:float

var collected:bool=false

func _ready():
	pass

func _physics_process(delta):
	global_transform.origin.z += Global.speed * delta

func handle_collision():
	if collected== false:
		collected = true
		if $AnimationPlayer.has_animation("glow"):
			$AnimationPlayer.play("glow")
		#$FeedbackSound.pitch_scale = randf()*0.5 + (1.2-(0.25/2))
		$FeedbackSound.play()
		Events.emit_signal("plant_collected", self)
		
