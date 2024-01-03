extends Label

func _process(delta):
	text = "Game Speed: " + str(Engine.time_scale * 100) + "%"
