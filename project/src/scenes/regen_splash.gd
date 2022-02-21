extends Node

onready var manager = Global.manager()

func _ready():
	pass


func _on_Timer_timeout():
	manager.load_scene(manager.menu_path, "menu")
