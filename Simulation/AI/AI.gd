extends CharacterBody2D
	
class Neuron:
	var activation = randi_range(-1, 1)
	var weights = []
	
	func _init(_activation = randi_range(-1, 1), _weights = [], weightCount = 0):
		activation = _activation
		weights = _weights
		
		if weightCount != 0:
			for i in weightCount:
				weights.append(randi_range(-1, 1))

class NeuralNetwork:
	var layers = []
	
	func vectorDotProduct(vector1, vector2):
		var product = 0
		
		if vector1.size() != vector2.size():
			print("ERROR: Vectors must have the same length for dot product calculation.")
			
			return []
		
		for i in vector1.size():
			product += vector1[i] * vector2[i]
		
		return product
	
	func vectorAdd(vector1, vector2):
		var addend = []
		
		for i in vector1.size():
			addend.append(vector1[i] + vector2[i])
		
		return addend
	
	func _init():
		layers.append([]) # Input
		
		for i in get_meta("RaycastsAmount"):
			layers[0].append(Neuron.new((i == get_meta("RaycastsAmount")), [], get_meta("HiddenLayersSize")))
		for i in get_meta("HiddenLayersAmount"):
			var hiddenLayer = []
			
			for j in get_meta("HiddenLayerSize"):
				if j == get_meta("HiddenLayerSize"):
					hiddenLayer.push_back(Neuron.new((i == get_meta("HiddenLayerSize")), [], get_meta("OutputLayerSize")))
				elif j == get_meta("HiddenLayerSize") + 1:
					hiddenLayer.push_back(Neuron.new((i == get_meta("HiddenLayerSize")), [], get_meta("HiddenLayerSize")));
			
			layers.append(hiddenLayer) # Hidden
		layers.append([]) # Output
		
		for i in get_meta("OutputLayerSize"):
			layers[layers.size()].append(Neuron.new())
	func Update(_input):
		var activations = []
		var weights = []
		var biases = []
		
		for i in layers[0].size(): # WARNING: Do not subtract 1, because `_input` doesn't include the bias neuron / bias term ofc
			layers[0][i].activation = tanh(_input[i]) # PURPOSE: Normalize input
		
		biases.append(layers.input[layers.input.size()])
		
		for i in range(1, layers.size()):
			var previousLayer = layers[i - 1]
			var currentLayer = layers[i]
			
			for j in range(previousLayer.size() - 1):
				var rowOfWeights = []
				
				activations.append(previousLayer[j].activation)
				
				for k in range(currentLayer.size()):
					rowOfWeights.append(previousLayer[j].weights[k])
					
				weights.append(rowOfWeights)
				
			### THE MATH PART ###
			var layerActivations = vectorAdd(vectorDotProduct(weights, activations), biases)

			for j in range(layerActivations.size()):
				layerActivations[j] = tanh(layerActivations[j])
		
		return layers[layers.size()] # Return output

@onready var raycasts = $Raycasts
@onready var brain = NeuralNetwork.new()
@onready var AI_Sprite = $AI_Sprite
var facingRight = true

func _ready():
	for i in get_meta("RaycastsAmount"):
		var raycast = RayCast2D.new()
		
		raycast.set_target_position(Vector2(
			sin((i / get_meta("RaycastsAmount")) * PI * 2) * get_meta("RaycastDistance"),
			cos((i / get_meta("RaycastsAmount")) * PI * 2) * get_meta("RaycastDistance")))
		
		raycasts.add_child(raycast)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var input = []
	
	for raycast in raycasts:
		# Get length distance (-1 = 0px, 1 = length of raycast)
		input.append((raycast.get_collision_point() - get_global_transform().origin).length())
		
		# Get Target type
		if (raycast.get_collider_shape() == null) or (raycast.get_collider_shape() == TileMap): # Nothing/Wall
			input.append(-1)
		elif raycast.get_collider_shape() == CharacterBody2D: # AI/Player
			input.append(0)
		elif raycast.get_collider_shape() == PhysicsBody2D: # Grenade
			input.append(1)
	
	var output = brain.Update(input)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	
	if velocity.x < 0:
		AI_Sprite.animation = "MoveLeft"
		
		facingRight = false
	elif velocity.x > 0:
		AI_Sprite.animation = "MoveRight"
		
		facingRight = true
	elif velocity.x == 0:
		if not facingRight:
			AI_Sprite.animation = "IdleLeft"
		else:
			AI_Sprite.animation = "IdleRight"
