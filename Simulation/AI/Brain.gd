class_name NeuralNetwork extends "AI.gd"

@export_category("Neural Network Layers")

@export_group("Input")
@export var RaycastsAmount : int = 16
@export var RaycastsDistance : float = 350

@export_group("Hidden")
@export var HiddenLayersAmount : int = 2
@export var HiddenLayerSize : int = 3

@export_group("Output")
@export var OutputLayerSize : int = 3

func matrixVectorMultiply(matrix : Array[Array], vector : Array[float]):
	var productVector : Array[float] = []
	
	if matrix.size() == 0 or matrix.front().size() != vector.size():
		print("Error: Incompatible matrix and vector dimensions for multiplication")
		
		return productVector
	
	for i in range(matrix.size()):
		var rowSum : float = 0
		
		for j in range(vector.size()):
			rowSum += matrix[i][j] * vector[j]
		
		productVector.append(rowSum)
	
	return productVector

func vectorAdd(vector1 : Array[float], vector2 : Array[float]):
	var addend : Array[float] = []
	
	for i in range(vector1.size()):
		addend.append(vector1[i] + vector2[i])
	
	return addend

var layers : Array[Array] = []

func _init():
	var inputLayer : Array[Neuron] = []
	
	for i in range(RaycastsAmount * 2 + 1): # `* 2` because of the distance and target type; `+ 1` because of the bias neuron
		if i == RaycastsAmount + 1: # If bias neuron
			inputLayer.append(Neuron.new(1, [], HiddenLayerSize))
		else:
			inputLayer.append(Neuron.new(randf_range(-1, 1), [], HiddenLayerSize))
	
	layers.append(inputLayer)
	
	for i in range(HiddenLayersAmount):
		var hiddenLayer : Array[Neuron] = []
		
		for j in range(HiddenLayerSize + 1):
			if i == HiddenLayersAmount: # If last hidden layer
				if j == HiddenLayerSize + 1: # If bias neuron
					hiddenLayer.append(Neuron.new(1, [], OutputLayerSize))
				else:
					hiddenLayer.append(Neuron.new(randf_range(-1, 1), [], OutputLayerSize))
			else:
				if j == HiddenLayerSize + 1: # If bias neuron
					hiddenLayer.append(Neuron.new(1, [], HiddenLayerSize))
				else:
					hiddenLayer.append(Neuron.new(randf_range(-1, 1), [], HiddenLayerSize))
		
		layers.append(hiddenLayer)
	var outputLayer : Array[Neuron] = []
	
	for i in range(OutputLayerSize): # No `+ 1` because the output layer has no bias neuron
		outputLayer.append(Neuron.new(0, [], 0))
	
	layers.append(outputLayer)

func Update(input : Array[float]):
	# Initialize input values
	for i in range(RaycastsAmount):
		layers.front()[i].activation = tanh(input[i])
	
	# Feed forward / Propagate forward
	for i in range(1, layers.size()): # For each layer (besides input layer)
		var previousLayer : Array[Neuron] = layers[i - 1]
		var currentLayer : Array[Neuron] = layers[i]
		
		var weights : Array[Array] = [] # Matrix
		var activations : Array[float] = [] # Vector
		var biases : Array[float] = previousLayer.back().weights # Vector
		
		for j in range(currentLayer.size() - 1): # For each weight in previousLayer connecting to currentLayer # `- 1` because of bias neuron
			var columnOfWeights : Array[float] = []
			
			for k in range(previousLayer.size() - 1): # For each neuron in previousLayer # `- 1` because of bias neuron
				columnOfWeights.append(previousLayer[k].weights[j])
			
			weights.append(columnOfWeights)
		
		for j in range(previousLayer.size() - 1): # For each neuron in previousLayer # `- 1` because of bias neuron
			activations.append(previousLayer[j].activation)
		
		# Equation: a¹=Wa⁰+b
		
		var layerActivations : Array[float] = vectorAdd(matrixVectorMultiply(weights, activations), biases)
		
		# Activation function: σ(x) = tanh(x)
		for j in range(layerActivations.size()):
			layerActivations[j] = tanh(layerActivations[j])
			currentLayer[j].activation = layerActivations[j]
	
	return layers.back() # Return output layer
