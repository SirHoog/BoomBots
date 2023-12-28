extends RigidBody2D

@export_category("Grenade")
@export_enum("Frag", "Impact") var Type : String = "Frag"
@export var FragDelay : float = 2
@export var SelfDamage : bool = false
@export var Knockback : float = 300
@export var Damage : float = 15
@export var DamageRadius : int = 100
@export var Owner : AI

func _ready():
	$Fuse.wait_time = FragDelay
	$ExplosionArea/Collision.scale = Vector2(DamageRadius, DamageRadius)

func _thrown(force : Vector2, owner : AI):
	linear_velocity = force
	Owner = owner
	
	$Fuse.start()

func _on_explode():
	$Explosion.play("default")
	
	for char in $ExplosionArea.get_overlapping_bodies():
		if char.is_class(AI):
			var distance : float = global_position.distance_to(char.global_position)
			var direction : Vector2 = char.global_position - global_position
			
			if char == Owner and not SelfDamage:
				return
			
			char.Health -= Damage
			char.Velocity += Knockback * direction * (distance / DamageRadius)
