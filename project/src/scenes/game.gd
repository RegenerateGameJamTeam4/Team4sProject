extends Spatial

export var camera_stickiness = 0.5
export var look_height = 0.05

var camera_follow=false

#references
onready var camera = $Camera
onready var player = $Player
onready var cursor = $target_cursor

const MAX_SUGARS = 100
const MAX_NUTRIENTS = 100
const MAX_COMMUNITY = 100

var sugars:int setget set_sugars
var nutrients:int setget set_nutrients
var community:int setget set_community
var generations:int setget set_generations


export var environment:Environment
export var sugar_decay_rate = 1.2
export var nutrients_decay_rate = 1.2
export var community_decay_rate = 1.2

export var decay_multipler = 1

var drain_delay:float = 1

onready var _manager = Global.manager()

var in_game = false
var game_ended=false

func _ready():
	Global.game = self
	_manager._environment.environment = environment
	reset_game()
	Events.connect("plant_collected", self, "_on_plant_collected")
	Events.connect("hit_rock", self, "_on_hit_rock")
	Events.connect("restart_btn_pressed", self, "_on_restart_btn_pressed")

	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func reset_game():
	get_tree().paused=false
	$FinalScore.visible=false
	self.sugars = 100
	self.nutrients = 100
	self.community = 100
	self.generations = 0

func set_sugars(newval):
	sugars = newval
	if sugars>=MAX_SUGARS : sugars = MAX_SUGARS
	if sugars<=0: sugars = 0
	if sugars == 0:
		gameover()
	Events.emit_signal("sugars_updated", sugars)

func set_nutrients(newval):
	nutrients = newval
	if nutrients>=MAX_NUTRIENTS : nutrients = MAX_NUTRIENTS
	if nutrients<=0: nutrients = 0
	if nutrients == 0:
		gameover()
	Events.emit_signal("nutrients_updated", nutrients)

func set_community(newval):
	community = newval
	if community>=MAX_COMMUNITY : nutrients = MAX_COMMUNITY
	if community<=0: community = 0
	if community == 0:
		gameover()
	Events.emit_signal("community_updated", community)
	
func set_generations(newval):
	generations = newval
	Events.emit_signal("generations_updated", generations)

func gameover():
	if game_ended==false:
		get_tree().paused=true
		game_ended==true
		$FinalScore/GameOverSound.play()
		$FinalScore.visible = true

func _on_restart_btn_pressed():
	_manager.load_scene(_manager.game_path, "game")

func _on_plant_collected(plant):
	plant = plant as Plant
	if plant.sugar_value>0:
		self.sugars += plant.sugar_value
	if plant.nutrient_value>0:
		self.nutrients += plant.nutrient_value
	if plant.community_value>0:
		self.community += plant.community_value

func drain_resources():
	self.sugars -= sugar_decay_rate * decay_multipler
	self.nutrients -= nutrients_decay_rate * decay_multipler
	self.community -= community_decay_rate * decay_multipler

func _physics_process(delta):
	
	#not used!
	if camera_follow:
		#camera.translation = camera.translation.linear_interpolate(player.translation, camera_stickiness)
		var camera_target = camera.global_transform.origin.linear_interpolate(player.global_transform.origin,camera_stickiness)
		camera.look_at(Vector3(camera_target.x*camera_stickiness,camera_target.y+look_height,camera_target.z*camera_stickiness),Vector3.UP)
		#camera.look_at(camera_target,Vector3.UP)
	

	var mouse_pos = get_viewport().get_mouse_position()
	
	#not used
#	var space_state = get_world().direct_space_state
#	var raycast = space_state.intersect_ray(camera.project_ray_origin(mouse_pos),
#							 camera.project_ray_normal(mouse_pos))
	
	var dropPlane  = Plane(Vector3(0, 0, 1), -0.5)
	var raycast_pos = dropPlane.intersects_ray(
							 camera.project_ray_origin(mouse_pos),
							 camera.project_ray_normal(mouse_pos))
	if raycast_pos:
		$target_cursor.global_transform.origin = raycast_pos
		player.target_location = $target_cursor.global_transform.origin


func _on_DrainTimer_timeout():
	drain_delay = drain_delay * 0.8
	self.generations+=1
	drain_resources()

func _on_hit_rock():
	self.sugars = sugars - rand_range(0,2)
	self.nutrients = nutrients - rand_range(0,2)
	self.community = community - rand_range(0,2)

func _on_StartTimer_timeout():
	$HUD.visible=true
	$DrainTimer.wait_time = drain_delay
	$DrainTimer.start()
