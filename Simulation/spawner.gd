extends Node

@export var PopulationSize : int = 5

func _ready():
	for i in range(PopulationSize):
		var AI_PackedScene : Resource = preload("res://Simulation/AI/AI.tscn")
		var AI : Node = AI_PackedScene.instantiate()
		var padding : int = 32 # Amount of pixels inside the map that it can't spawn in
		
		add_child(AI)
		
		AI.position = Vector2(randi_range(padding, 1024 - padding), randi_range(padding, 576 - padding))
