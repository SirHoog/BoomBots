extends Node

func _on_ai_throw_grenade(force, owner):
	var grenadePackedScene : Resource = preload("res://Simulation/AI/AI.tscn")
	var grenade : Node = grenadePackedScene.instantiate()
	var padding : int = 32 # Amount of pixels inside the map that it can't spawn in
	
	add_child(grenade)
	
	grenade.position = owner.position
	grenade.velocity = force
