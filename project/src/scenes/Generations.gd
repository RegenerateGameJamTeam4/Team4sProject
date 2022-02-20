extends Label

func _ready():
	Events.connect("generations_updated", self, "_on_generations_updated")
	
func _on_generations_updated(new_value):
	text = str(new_value)
