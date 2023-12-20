extends Node
class_name Neuron

var activation : float = randi_range(-1, 1)
var weights : Array[float] = []

func _init(_activation : float = randi_range(-1, 1), _weights : Array[float] = [], weightsCount : int = 0):
	activation = _activation
	
	if (weightsCount != 0):
		for i in range(weightsCount):
			weights.append(randi_range(-1, 1))
	else:
		weights = _weights
