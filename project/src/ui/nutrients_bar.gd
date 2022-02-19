extends ProgressBar

func _ready():
	Events.connect("plant_collected", self, "_on_plant_collected")
	
func _on_plant_collected(plant):
	plant = plant as Plant
	if plant.nutrient_value>0:
		value+=plant.nutrient_value
