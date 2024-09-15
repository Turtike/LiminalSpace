@tool
extends Node3D

@export var path: Path3D: set = set_path
@export var scene: PackedScene: set = set_scene
@export var scene_distance: float = 10.0: set = set_scene_distance
@export var scene_offset: Vector3 = Vector3.ZERO: set = set_scene_offset
@export var update: bool = false: set = set_update

var spawned_scenes: Array

var path_segment: PackedScene = preload("res://scenes/gravity_path/gravity_path_segment.tscn")

func set_update(state: bool) -> void:
	update = state
	update_segments()

func set_scene(p_scene: PackedScene) -> void:
	scene = p_scene
	update_segments()

func set_path(p_path: Path3D) -> void:
	if path:
		path.disconnect("curve_changed", on_curve_changed)
	path = p_path
	if path:
		path.connect("curve_changed", on_curve_changed)
	update_segments()

func set_scene_offset(p_offset: Vector3) -> void:
	scene_offset = p_offset
	update_segments()

func set_scene_distance(p_offset: float) -> void:
	scene_distance = p_offset
	update_segments()

func on_curve_changed():
	update_segments()


func remove_segments() -> void:
	for child in spawned_scenes:
		remove_child(child)
		child.queue_free()
	spawned_scenes.clear()


func update_segments() -> void:
	if not update or not Engine.is_editor_hint():
		return
	
	remove_segments()
	
	if path == null:
		return
	
	var path_length: float = path.curve.get_baked_length()
	var scene_count: int = int(path_length/scene_distance)
	for i in range(0, scene_count):
		var offset = i * scene_distance
		var pos = path.curve.sample_baked(offset, false)
		var forward = pos.direction_to(path.curve.sample_baked(offset + 0.01, false))
		var up = path.curve.sample_baked_up_vector(offset, true)
		
		var new_scene := scene.instantiate()
		spawned_scenes.append(new_scene)
		add_child(new_scene)
		new_scene.owner = self.owner
		new_scene.position = pos + path.position
		new_scene.basis.x = forward.cross(up).normalized()
		new_scene.basis.y = up
		new_scene.basis.z = -forward
		new_scene.basis = new_scene.basis.orthonormalized()
		new_scene.translate_object_local(scene_offset)
