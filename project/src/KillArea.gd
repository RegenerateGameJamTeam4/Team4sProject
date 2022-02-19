extends Area

func _ready():
	pass # Replace with function body.


func _on_KillArea_area_entered(area):
	area.queue_free()
