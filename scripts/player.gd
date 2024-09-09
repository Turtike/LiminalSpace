class_name GravityCharacterBody3D
extends CharacterBody3D

var local_velocity: Vector3
var h_rotation: float = 0

@onready var state_machine:AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

const SPEED = 3.0
const JUMP_VELOCITY = 5.0
const JUMP_SPEED = 2.0
const FALL_MULTIPLIER = 1.5
const ACCELERATION = 0.1
const DECELERATION = 0.2


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$AnimationTree.active = true
	state_machine.start("walking")
	

func rotate_horizontal(angle) -> void:
	h_rotation += angle
	if h_rotation > PI:
		h_rotation -= PI * 2
	elif h_rotation < -PI:
		h_rotation += PI * 2

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if local_velocity.y < 0:
			local_velocity.y -= get_gravity().length() * delta * FALL_MULTIPLIER
		else:
			local_velocity.y -= get_gravity().length() * delta
		update_velocity_and_transform()
		move_and_slide()
		return
	
	local_velocity.y = 0
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		if not state_machine.get_current_node() == "walking":
			state_machine.travel("walking")
		var target_velocity = direction * SPEED
		#print(target_velocity)
		local_velocity.x = move_toward(local_velocity.x, target_velocity.x, abs(direction.x) * ACCELERATION)
		local_velocity.z = move_toward(local_velocity.z, target_velocity.z, abs(direction.z) * ACCELERATION)
	else:
		if not state_machine.get_current_node() == "RESET":
			state_machine.travel("RESET")
			#print("stop")
		var normal_velocity = local_velocity.normalized()
		local_velocity.x = move_toward(local_velocity.x, 0, abs(normal_velocity.x) * DECELERATION)
		local_velocity.z = move_toward(local_velocity.z, 0, abs(normal_velocity.z) * DECELERATION)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if not state_machine.get_current_node() == "RESET":
			state_machine.travel("RESET")
			#print("stop")
		local_velocity.x = clamp(local_velocity.x, -direction.x * JUMP_SPEED, direction.x * JUMP_SPEED)
		local_velocity.z = clamp(local_velocity.z, -direction.x * JUMP_SPEED, direction.z * JUMP_SPEED)
		local_velocity.y = JUMP_VELOCITY
	
	#print(rotation)
	update_velocity_and_transform()
	move_and_slide()

func update_velocity_and_transform():
	# Reset Basis
	transform.basis = Basis()
	transform.basis = transform.basis.rotated(Vector3.UP, h_rotation)
	
	var rotation_axis = Vector3.UP.cross(up_direction.normalized()).normalized()
	if rotation_axis != Vector3.ZERO:
		var rotation_angle = Vector3.UP.angle_to(up_direction)
		transform.basis = transform.basis.rotated(rotation_axis, rotation_angle)
	transform.basis = basis.orthonormalized()

	velocity = transform.basis * local_velocity
	
func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_left"):
		var tween = create_tween()
		tween.tween_property(self, "up_direction", Vector3(0.1, 0, -1), 0.5)
		
	if event.is_action_pressed("ui_right"):
		var tween = create_tween()
		tween.tween_property(self, "up_direction", Vector3.BACK, 0.5)
		
	if event.is_action_pressed("ui_down"):
		var tween = create_tween()
		tween.tween_property(self, "up_direction", Vector3.UP, 0.5)
