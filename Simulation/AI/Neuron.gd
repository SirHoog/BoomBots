extends Node
class_name Neuron

var activation : float = randi_range(-1, 1)
var weights : Array[float] = []

func _init(_activation : float = randi_range(-1, 1), _weights : Array[float] = [], weightCount : int = 0):
	activation = _activation
	weights = _weights
	
	if weightCount != 0:
		for i in weightCount:
			weights.append(randi_range(-1, 1))
