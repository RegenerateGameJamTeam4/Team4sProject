extends Node

export (String, "RegenSplash", "Menu","Game") var debug_start_scene
var splash_path = "res://src/scenes/regen_splash.tscn"
var menu_path = "res://src/scenes/main_menu.tscn"
var game_path = "res://src/scenes/game.tscn"

export var transitions_enabled = false

# Scene loader variables
var scenes_holder : Node;
var loaded_scenes_map = {}
var loaded_scenes_list : Array = []

var first:bool = true

# References to objects
# to come...
onready var _musicplayer = $Music
onready var _ambientplayer = $Ambience
onready var _environment = $WorldEnvironment


func _ready():
	match (debug_start_scene):
		"RegenSplash":
			load_scene(splash_path, "splash")
		"Menu":
			load_scene(menu_path, "menu")
		"Game":
			load_scene(game_path, "game")

	pause_mode = Node.PAUSE_MODE_PROCESS;
	scenes_holder.pause_mode = Node.PAUSE_MODE_STOP;

	get_tree().paused=false
	
	set_process(false)

func _enter_tree():
	print ("enter tree")
	add_to_group("global_game_manager");
	
	#create a node called scenes holder
	scenes_holder = Node.new();
	scenes_holder.name="ScenesHolder"
	add_child(scenes_holder)

# Adds a scene to the tree via load_scene and unloads all other scenes
func change_scene(scene, unique_id: String) -> bool:
	return load_scene(scene, unique_id);

# Adds a scene to the tree via load_scene without unloading any other scenes
func add_scene(scene, unique_id: String) -> bool:
	return load_scene(scene, unique_id, true)

# Loads a scene to the manager with the specified unique_id. If additive is
# true then the scene will be loaded parallel to other scenes, otherwise all other
# scenes will be unloaded before this one is loaded. The scene can either be a path
# to the resource or a PackedScene. Returns true on success, false otherwise.
func load_scene(scene, unique_id: String, additive = false) -> bool:
	
	if transitions_enabled:
		if first==true:
			$Transition.visible=false
		else:
			$Transition.get_node("AnimationPlayer").play("fade")
			yield($Transition.get_node("AnimationPlayer"), "animation_finished")

	var to_load : PackedScene;
	
	if scene is String:
		to_load = load(scene);
	elif scene is PackedScene:
		to_load = scene;
	else:
		return false;
		
	if not additive:
		for loaded_scene in loaded_scenes_list:
			loaded_scene.queue_free()
		loaded_scenes_list.clear()
		loaded_scenes_map = {}
	
	if loaded_scenes_map.has(unique_id):
		return false
		
	var new_scene = to_load.instance()
	loaded_scenes_map[unique_id] = new_scene
	loaded_scenes_list.append(new_scene)
	
	scenes_holder.add_child(new_scene, true)
	print("Memory: " + str(OS.get_static_memory_peak_usage()))
	
	if transitions_enabled:
		if first==false:
			yield(get_tree().create_timer(1.1), "timeout")
			$Transition.get_node("AnimationPlayer").play_backwards("fade")
		#yield(transition.get_node("AnimationPlayer"), "animation_finished")
	
	first=false
	
	return true

# Unloads the scene with the specified unique_id. If a camera has been registered
# to that scene that camera is deleted too.
func unload_scene(unique_id : String):
	if loaded_scenes_map.has(unique_id):
		loaded_scenes_list.erase(loaded_scenes_map[unique_id])
		loaded_scenes_map[unique_id].queue_free()
		loaded_scenes_map.erase(unique_id)
