extends Area

export(String, "tree", "shrub", "vegetable") var type = ""
export var sunlight_value:float
export var sugar_value:float
export var carbon_value:float
export var nitrogen_value:float
export var calcium_value:float

func _ready():
	pass

func _physics_process(delta):
	global_transform.origin.z += Global.speed * delta
