class_name GravityCharacterBody3D
extends CharacterBody3D

var local_velocity: Vector3
var h_rotation: float = 0
var speed: float = 0
var jump_queued: bool = false

@onready var state_machine:AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

const WALK_SPEED = 3.0 #m/s
const RUN_SPEED = 5.0 #m/s
const JUMP_VELOCITY = 5.0
const SMALL_JUMP_SPEED = 2.0
const LANDING_SPEED_LOSS = 1.0
const FALL_MULTIPLIER = 1.5
const ACCELERATION = 18.0 #m/s^2
const DECELERATION = 20.0 #m/s^2


func _ready() -> void:
	h_rotation = rotation.y
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$AnimationTree.active = true
	state_machine.start("idle")
	

func rotate_horizontal(angle) -> void:
	h_rotation += angle
	if h_rotation > PI:
		h_rotation -= PI * 2
	elif h_rotation < -PI:
		h_rotation += PI * 2

func _physics_process(delta: float) -> void:
	print(state_machine.get_current_node())
	# Add the gravity.
	if not is_on_floor():
		if local_velocity.y < 0:
			local_velocity.y -= get_gravity().length() * delta * FALL_MULTIPLIER
			if $QueueJump.is_colliding() and Input.is_action_pressed("jump"):
				jump_queued = true
		else:
			local_velocity.y -= get_gravity().length() * delta
		update_velocity_and_transform()
		move_and_slide()
		return
	
	if $AnimationTree.get("parameters/conditions/landing") == false:
		$AnimationTree.set("parameters/conditions/jumping", false)
		$AnimationTree.set("parameters/conditions/landing", true)
		speed -= LANDING_SPEED_LOSS
		local_velocity.y = 0
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		$AnimationTree.set("parameters/conditions/idle", false)
		$AnimationTree.set("parameters/conditions/walking", true)
		speed += ACCELERATION * delta
		if Input.is_action_pressed("run"):
			speed = clamp(speed, 0, RUN_SPEED)
		else:
			speed = clamp(speed, 0, WALK_SPEED)
		
		local_velocity.x = direction.x * speed
		local_velocity.z = direction.z * speed
	else:
		$AnimationTree.set("parameters/conditions/idle", true)
		$AnimationTree.set("parameters/conditions/walking", false)
			#print("stop")
		speed -= DECELERATION * delta
		if speed < 0: speed = 0
		var normal_velocity = local_velocity.normalized()
		local_velocity.x = normal_velocity.x * speed
		local_velocity.z = normal_velocity.z * speed

	# Handle jump.
	if (Input.is_action_pressed("jump") or jump_queued) and is_on_floor() and\
		not state_machine.get_current_node() in ["jumping", "landing"]:
		$AnimationTree.set("parameters/conditions/idle", false)
		$AnimationTree.set("parameters/conditions/walking", false)
		$AnimationTree.set("parameters/conditions/landing", false)
		$AnimationTree.set("parameters/conditions/jumping", true)
		jump_queued = false
		if speed <= WALK_SPEED:
			var normal_velocity = local_velocity.normalized()
			local_velocity.x = clamp(local_velocity.x, local_velocity.x, normal_velocity.x * SMALL_JUMP_SPEED)
			local_velocity.z = clamp(local_velocity.z, local_velocity.z, normal_velocity.z * SMALL_JUMP_SPEED)
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
