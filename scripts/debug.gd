extends Node

var override_player_pos: bool = false
var player_spawn: Vector3 = Vector3.ZERO

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("spawn_location_override"):
		player_spawn = node.global_position
		print(player_spawn)
	
	if override_player_pos:
		call_deferred("set_player_pos")


func set_player_pos() -> void:
	for player in get_tree().get_nodes_in_group("player"):
		player.global_position = player_spawn
	
