extends CSGBox3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_static_body_3d_interacted(body: Variant) -> void:
	$Button.set_collision_layer_value(2, false)
	$Button.visible = false
	for node in get_tree().get_nodes_in_group("platform_2"):
		node.move_up()
