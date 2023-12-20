extends Node
class_name NeuralNetwork

@export_category("Neural Network Layers")

@export_group("Input")
@export var RaycastsAmount : int = 16
@export var RaycastsDistance : float = 250

@export_group("Hidden")
@export var HiddenLayersAmount : int = 2
@export var HiddenLayerSize : int = 3

@export_group("Output")
@export var OutputLayerSize : int = 3

func vectorDotProduct(vector1, vector2):
	var product : Array[float] = []
	
	if vector1.size() != vector2.size():
		print("ERROR: Vectors must have the same length for dot product calculation.")
		
		print(vector1.size())
		print(vector2.size())
		
		return []
	
	for i in range(vector1.size()):
		product += vector1[i] * vector2[i]
	
	return product

func vectorAdd(vector1, vector2):
	var addend : Array[float] = []
	
	for i in range(vector1.size()):
		addend.append(vector1[i] + vector2[i])
	
	return addend

var layers : Array[Array] = []

func _ready():
	var raycasts : Node = get_node("../Raycasts")
	
	for i in range(RaycastsAmount):
		var raycast : RayCast2D = RayCast2D.new()
		
		raycast.set_target_position(Vector2(
			sin((i / RaycastsAmount) * PI * 2) * RaycastsDistance,
			cos((i / RaycastsAmount) * PI * 2) * RaycastsDistance))
		
		raycasts.add_child(raycast)

func _init():
	var inputLayer : Array[Neuron] = []
	
	for i in range(RaycastsAmount + 1):
		if i == RaycastsAmount + 1: # If bias neuron
			inputLayer.append(Neuron.new(1, [], HiddenLayerSize))
		else:
			inputLayer.append(Neuron.new(randi_range(-1, 1), [], HiddenLayerSize))
	
	layers.append(inputLayer)
	
	for i in range(HiddenLayersAmount):
		var hiddenLayer : Array[Neuron] = []
		
		for j in range(HiddenLayerSize + 1):
			if i == HiddenLayersAmount: # If last hidden layer
				if j == HiddenLayerSize + 1: # If bias neuron
					hiddenLayer.append(Neuron.new(1, [], OutputLayerSize))
				else:
					hiddenLayer.append(Neuron.new(randi_range(-1, 1), [], OutputLayerSize))
			else:
				if j == HiddenLayerSize + 1: # If bias neuron
					hiddenLayer.append(Neuron.new(1, [], HiddenLayerSize))
				else:
					hiddenLayer.append(Neuron.new(randi_range(-1, 1), [], HiddenLayerSize))
		
		layers.append(hiddenLayer)
	var outputLayer : Array[Neuron] = []
	
	for i in range(OutputLayerSize): # No `+ 1` because the output layer has no bias neuron
		outputLayer.append(Neuron.new(0, [], 0))
	
	layers.append(outputLayer)

func Update(input : Array[float]):
	var activations : Array[float] = []
	var weights : Array[float] = []
	var biases : Array[float] = []
	
	for i in range(RaycastsAmount):
		layers.front()[i].activation = tanh(input[i]) # Normalize input
	
	biases.append(layers.front().back().activation) # Last neuron of input is the bias neuron
	
	for i in range(1, layers.size()): # For each layer (besides input layer)
		var previousLayer : Array[Neuron] = layers[i - 1]
		var currentLayer : Array[Neuron] = layers[i]
		
		for j in range(previousLayer.size() - 1): # For each neuron (besides bias neuron)
			activations.append(previousLayer[j].activation)
			
			for k in range(currentLayer.size() - 1): # For each weight
				weights.append(previousLayer[j].weights[k])
		
		### THE MATH PART ###
		var layerActivations : Array[float] = vectorAdd(vectorDotProduct(weights, activations), biases)
		
		for j in range(layerActivations.size()):
			layerActivations[j] = tanh(layerActivations[j])
	
	return layers.back() # Return output layer
