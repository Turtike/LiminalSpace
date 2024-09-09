@tool
extends Node3D

@export var path: Path3D: set = set_path
@export var segment_size: Vector3 = Vector3(0.3, 0.5, 3): set = set_segment_size
@export var segment_offset: Vector3 = Vector3.ZERO: set = set_segment_offset
@export var update: bool = false: set = set_update

var path_segment: PackedScene = preload("res://scenes/gravity_path/gravity_path_segment.tscn")

func set_update(state: bool) -> void:
	update = state
	update_segments()

func set_path(p_path: Path3D) -> void:
	if path:
		path.disconnect("curve_changed", on_curve_changed)
	path = p_path
	if path:
		path.connect("curve_changed", on_curve_changed)
	update_segments()


func set_segment_size(p_size: Vector3) -> void:
	segment_size = p_size
	segment_size.z = clamp(segment_size.z, 0.2, segment_size.z)
	update_segments()

func set_segment_offset(p_offset: Vector3) -> void:
	segment_offset = p_offset
	update_segments()

func on_curve_changed():
	update_segments()


func remove_segments() -> void:
	for child in get_children():
		if child is GravityPathSegment:
			remove_child(child)
			child.queue_free()


func update_segments() -> void:
	if not update or not Engine.is_editor_hint():
		return
	
	remove_segments()
	
	if path == null:
		return
	
	var path_length: float = path.curve.get_baked_length()
	var segment_count: int = int(path_length/segment_size.z)
	for i in range(0, segment_count):
		var offset = i * segment_size.z
		var pos = path.curve.sample_baked(offset, false)
		var forward = pos.direction_to(path.curve.sample_baked(offset + 0.01, false))
		var up = path.curve.sample_baked_up_vector(offset, true)
		
		var new_segment: GravityPathSegment = path_segment.instantiate()
		new_segment.set_size(segment_size)
		add_child(new_segment)
		new_segment.owner = self.owner
		new_segment.position = pos + path.position
		new_segment.basis.x = forward.cross(up).normalized()
		new_segment.basis.y = up
		new_segment.basis.z = -forward
		new_segment.basis = new_segment.basis.orthonormalized()
		new_segment.translate_object_local(segment_offset)
