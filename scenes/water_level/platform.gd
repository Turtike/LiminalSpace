extends CSGBox3D

@export var target_pos: Vector3

func move_up():
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, 3)
	
