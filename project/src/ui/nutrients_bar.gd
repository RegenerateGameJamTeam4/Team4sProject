extends ProgressBar

func _ready():
	Events.connect("nutrients_updated", self, "_on_nutrients_updated")
	
func _on_nutrients_updated(new_value):
	value = new_value
	$NutrientsLabel.text = "Nutrients: " + str(new_value)
