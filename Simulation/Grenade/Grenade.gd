extends RigidBody2D

@export_category("Grenade")
@export_enum("Frag", "Impact") var Type : String = "Frag"
@export var FragExplosionTime : float = 2
@export var Damage : int = 15
@export var DamageRadius : int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	$Fuse.wait_time = FragExplosionTime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
