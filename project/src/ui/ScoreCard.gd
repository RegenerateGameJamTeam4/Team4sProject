extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("generations_updated", self, "_on_generations_updated")

func _on_generations_updated(value):
	$VBoxContainer/GenerationsLabel.text = str(value)

func _on_RestartButton_button_down():
		Events.emit_signal("restart_btn_pressed")
