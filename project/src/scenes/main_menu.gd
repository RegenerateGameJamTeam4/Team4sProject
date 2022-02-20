extends Spatial

export var environment:Environment

onready var manager = Global.manager()

var begin = false
var faded_in = false

func _ready():
	manager._environment.environment = environment
	$AnimationPlayer.play("fade_in")
	yield($AnimationPlayer,"animation_finished")
	faded_in=true
	

func _process(delta):
	if faded_in == true:
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and begin==false:
			begin = true
			manager._musicplayer.play()
			$AnimationPlayer.play("fade_out")

func start_game():
	manager.load_scene(manager.game_path,"game")
