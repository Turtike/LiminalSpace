extends Camera3D

@export var player: GravityCharacterBody3D

var vertical_bound = Vector2(-PI/2, PI/2)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var flip: int = 1 if UserSettings.mouse_inverted else -1
		rotation.x += event.relative.y * UserSettings.mouse_sensitivity * flip
		rotation.x = clamp(rotation.x, vertical_bound.x, vertical_bound.y)
		player.rotate_horizontal(event.relative.x * UserSettings.mouse_sensitivity * flip)
