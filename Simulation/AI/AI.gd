extends CharacterBody2D
class_name AI

@export_category("AI Physics")
@export var CollideWithOthers : bool = true
@export var WalkSpeed : float = 30
@export var JumpPower : float = 600

@onready var raycasts : Node = $Raycasts
@onready var brain : NeuralNetwork = NeuralNetwork.new()
@onready var AI_Sprite : AnimatedSprite2D = $AI_Sprite
var facingRight : bool = true

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var input : Array[float] = []
	
	for raycast in raycasts.get_children():
		# Get length distance (-1 = 0px, 1 = length of raycast)
		input.append((raycast.get_collision_point() - get_global_transform().origin).length())
		
		# Get Target type
		if bool(!raycast.get_collider_shape()) or bool(raycast.get_collider_shape() == TileMap): # Nothing/Wall
			input.append(-1)
		elif raycast.get_collider_shape() == CharacterBody2D: # AI/Player
			input.append(0)
		elif raycast.get_collider_shape() == PhysicsBody2D: # Grenade
			input.append(1)
	
	var output : Array[Neuron] = brain.Update(input)
	
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
