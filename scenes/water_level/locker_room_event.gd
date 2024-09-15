extends Node3D

@export var red_light: Node3D
@export var normal_light: Array[Node3D]
@export var collect_sfx: AudioStreamPlayer3D
@export var collectable: Interactable

func _ready() -> void:
	# lights were glitching out if they started off hidden
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(turn_off_light)
	timer.start(1)
	

func turn_off_light():
	for light in normal_light:
		light.visible = false

func _on_collectable_interacted(body: Variant) -> void:
	red_light.active = false
	red_light.visible = false
	for light in normal_light:
		light.visible = true
	collect_sfx.play()
	collectable.visible = false
	collectable.set_collision_layer_value(2, false)
	for node in get_tree().get_nodes_in_group("beginning_blocker"):
		node.visible = false
		node.queue_free()
		
	for node in get_tree().get_nodes_in_group("lobby_beginning_light"):
		node.visible = false
	for node in get_tree().get_nodes_in_group("lobby_lights"):
		node.visible = true
