extends Node2D

@export var Factor : float = 2
@export var MinimumSpeed = 0.25
@export var MaximumSpeed = 4096

func _input(event):

	
	if event.is_action_released("SpeedUp"):
		Engine.time_scale *= Factor
	elif event.is_action_released("SlowDown"):
		Engine.time_scale /= Factor
	elif event.is_action_released("Pause"):
		Engine.time_scale = (Engine.time_scale == 0)
	
	Engine.time_scale = clamp(Engine.time_scale, MinimumSpeed, MaximumSpeed)
