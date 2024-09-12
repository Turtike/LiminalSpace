extends Node3D
@export var door_area: Area3D: set = set_door_area
@export var push_forward: Area3D: set = set_push_forward
@export var push_back: Area3D: set = set_push_back
@export var open_forward_degrees: float = 180
@export var open_back_degrees: float = 180
@export var open_forward_time_secs: float = 1
@export var open_back_time_secs: float = 1
@export var door_close_time_secs: float = 1

var close_tween: Tween

var door_opened: bool = false
var player_in_range: bool = false

func set_door_area(area: Area3D) -> void:
	if door_area != null:
		door_area.body_entered.disconnect(_on_door_area_entered)
		door_area.body_exited.disconnect(_on_door_area_exited)
	door_area = area
	door_area.body_entered.connect(_on_door_area_entered)
	door_area.body_exited.connect(_on_door_area_exited)

func set_push_forward(area: Area3D) -> void:
	if push_forward != null:
		push_forward.body_entered.disconnect(_on_push_forward)
	push_forward = area
	push_forward.body_entered.connect(_on_push_forward)

func set_push_back(area: Area3D) -> void:
	if push_back != null:
		push_back.body_entered.disconnect(_on_push_back)
	push_back = area
	push_back.body_entered.connect(_on_push_back)


func _on_door_area_entered(body) -> void:
	player_in_range = true
	$Timer.stop()
	if close_tween:
		close_tween.kill()
	
func _on_door_area_exited(body) -> void:
	player_in_range = false
	$Timer.start(door_close_time_secs)

func _on_timer_timeout() -> void:
	door_opened = false
	close_tween = $DoorPivot.create_tween()
	close_tween.tween_property($DoorPivot, "rotation_degrees", Vector3.ZERO, door_close_time_secs)
	#close_tween.tween_callback(finished_close)

func finished_close():
	print("finished_close")

func _on_push_forward(body) -> void:
	if !player_in_range or door_opened:
		return
	var target_rotation: Vector3 = Vector3(0, open_forward_degrees, 0)
	var tween: Tween = $DoorPivot.create_tween()
	tween.tween_property($DoorPivot, "rotation_degrees", target_rotation, open_forward_time_secs)
	#tween.tween_callback(finished_open_front)
	door_opened = true

func finished_open_front():
	print("finished_open_front")

func _on_push_back(body) -> void:
	if !player_in_range or door_opened:
		return
	var target_rotation: Vector3 = Vector3(0, open_back_degrees, 0)
	var tween: Tween = $DoorPivot.create_tween()
	tween.tween_property($DoorPivot, "rotation_degrees", -target_rotation, open_back_time_secs)
	#tween.tween_callback(finished_open_back)
	door_opened = true

func finished_open_back():
	print("finished_open_back")
