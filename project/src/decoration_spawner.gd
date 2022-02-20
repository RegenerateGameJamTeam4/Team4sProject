extends Spatial

var assetlist = [preload("res://src/Decoration/grass_001.tscn"),
				preload("res://src/Decoration/grass_002.tscn"),
				preload("res://src/Decoration/grass_003.tscn"),
				preload("res://src/Decoration/grass_004.tscn"),
				preload("res://src/Decoration/tiny_plant_001.tscn"),
				preload("res://src/Decoration/tiny_plant_002.tscn"),
				preload("res://src/Decoration/tiny_plant_003.tscn"),
				preload("res://src/Decoration/flower_001.tscn"),
				preload("res://src/Decoration/flower_002.tscn"),
				preload("res://src/Decoration/flower_003.tscn"),
				]

export var wait_range:Vector2
export var spawn_range:Vector2

func _ready():
	$SpawnTimer.start()
	

func spawn(random=true):
	var pick = randi()%assetlist.size()
	var new_asset = assetlist[pick].instance()
	new_asset.transform.origin = Vector3(rand_range(spawn_range.x,spawn_range.y), 0, 0)
	add_child(new_asset)


func _on_SpawnTimer_timeout():
	$SpawnTimer.wait_time = rand_range(wait_range.x,wait_range.y)
	spawn()
