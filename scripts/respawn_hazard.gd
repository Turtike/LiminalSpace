extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_enetered)

func _on_body_enetered(body):
	body.global_position = Respawn.respawn_position
	body.global_rotation = Respawn.respawn_rotation
