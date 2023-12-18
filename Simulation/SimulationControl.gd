extends Node2D

func _input(event):
	if event.is_action_released("SpeedUp"):
		Engine.time_scale *= 1.25
	elif event.is_action_released("SlowDown"):
		Engine.time_scale /= 1.25
	elif event.is_action_released("Pause"):
		Engine.time_scale = (Engine.time_scale == 0)
	
	Engine.time_scale = clamp(Engine.time_scale, 0, 10_000)
	
	if Engine.time_scale > 10:
		Engine.time_scale = round(Engine.time_scale)
