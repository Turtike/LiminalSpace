extends Area3D
class_name RespawnArea

@export var spawn_location: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_enetered)

func _on_body_enetered(_body):
	Respawn.respawn_position = spawn_location.global_position
	Respawn.respawn_rotation = spawn_location.global_rotation
