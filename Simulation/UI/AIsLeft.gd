extends Label

func _process(delta):
	text = "AIs Left: " + str(get_tree().get_nodes_in_group("Population").size())
