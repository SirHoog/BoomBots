extends CharacterBody2D
class_name AI

signal throw_grenade(force : Vector2, owner : AI)

@export_category("AI")
@export var CollideWithOthers : bool = true
@export var WalkSpeed : float = 100
@export var JumpPower : float = 400
@export var Health : float = 100

@onready var brain : NeuralNetwork = NeuralNetwork.new()
@onready var AI_Sprite : AnimatedSprite2D = $AI_Sprite
var facingRight : bool = true

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var input : Array[float] = []
	
	for i in range($Brain.RaycastsAmount):
		var spaceState : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		var query : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(
			sin((i / $Brain.RaycastsAmount) * PI * 2) * $Brain.RaycastsDistance,
			cos((i / $Brain.RaycastsAmount) * PI * 2) * $Brain.RaycastsDistance))
			
		query.exclude = [self]
		query.collide_with_areas = true
		
		var raycast : Dictionary = spaceState.intersect_ray(query)
		
		# Get length distance (-1 = 0px, 1 = length of raycast)
		if raycast.size() != 0:
			input.append((raycast.position - get_global_transform().origin).length() / $Brain.RaycastsDistance)
			
			# Get Target type
			if raycast.collider is TileMap: # Wall
				input.append(-1)
			elif raycast.collider is CharacterBody2D: # AI/Player
				input.append(0)
			elif raycast.collider is Area2D: # Grenade
				input.append(1)
		else:
			input.append(1) # Hit nothing, so max distance covered
			input.append(-1) # Hit nothing
	
	var output : Array[Neuron] = brain.Update(input)
	
	velocity.x = WalkSpeed * output.front().activation
	
	if output[1].activation > 0 and is_on_floor():
		velocity.y -= JumpPower
	
	if output[2].activation > 0:
		print("GRENADE!")
		
		emit_signal("throw_grenade", Vector2(
			sin(output[3].activation * PI * 2) * output[4].activation,
			cos(output[3].activation * PI * 2) * output[4].activation,
			), self)

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
