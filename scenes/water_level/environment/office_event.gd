extends Node3D

@export var switch: Interactable
@export var pool_platforms: Node3D
@export var switch_target_rotation: Vector3 = Vector3(-33.6, 0, 0)
@export var pool_platforms_target_position: Vector3

func _ready() -> void:
	switch.interacted.connect(_on_office_switch_interacted)
	

func _on_office_switch_interacted(_body):
	switch.input_ray_pickable = false
	switch.set_collision_layer_value(2, false)
	var tween_switch: Tween = switch.create_tween()
	tween_switch.tween_property(switch, "rotation_degrees", switch_target_rotation, 0.5)
	
	var tween_pool_platforms: Tween  = pool_platforms.create_tween()
	tween_pool_platforms.tween_property(pool_platforms, "position", pool_platforms_target_position, 0.5)
	
	for node in get_tree().get_nodes_in_group("platform_1"):
		node.move_up()
	
	$MoveSnd.play()
