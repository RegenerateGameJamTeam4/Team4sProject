extends Spatial

export var camera_stickiness = 0.15

#references
onready var camera = $Camera
onready var player = $Player


func _ready():
	pass

func _physics_process(delta):
	#camera.translation = camera.translation.linear_interpolate(player.translation, camera_stickiness)
	pass
