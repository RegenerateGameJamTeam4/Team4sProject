extends ProgressBar

func _ready():
	Events.connect("community_updated", self, "_on_community_updated")
	
func _on_community_updated(new_value):
	value = new_value
	$CommunityLabel.text = "Community: " + str(new_value)
