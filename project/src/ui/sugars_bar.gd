extends ProgressBar

func _ready():
	Events.connect("sugars_updated", self, "_on_sugars_updated")
	
func _on_sugars_updated(new_value):
	value = new_value
	$SugarsLabel.text = "Sugars: " + str(new_value)
