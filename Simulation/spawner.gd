extends Node

func _ready():
	for i in get_meta("PopulationSize"):
		var AI_PackedScene = preload("res://Simulation/AI/AI.tscn")
		var AI = AI_PackedScene.instantiate()
		var padding = 32 # Amount of pixels inside the map that it can't spawn in
		
		add_child(AI)
		
		AI.position = Vector2(randi_range(padding, 1024 - padding), randi_range(padding, 576 - padding))
