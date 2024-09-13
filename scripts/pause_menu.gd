extends Control

@export var scroll_background: TextureRect
@export var master_volume_slider: Range
@export var brightness_slider: Range
@export var volume_min: float = -50.0
@export var volume_max: float = 50.0
@export var brightness_min: float = 0
@export var brightness_max: float = 0.1

var player_camera: Camera3D

var scroll_speed: float = 5

func _ready() -> void:
	var index = AudioServer.get_bus_index("Master")
	master_volume_slider.ratio = inverse_lerp(volume_min, volume_max, AudioServer.get_bus_volume_db(index))
	
	var cameras = get_tree().get_nodes_in_group("player_camera")
	if !cameras:
		return
	player_camera = (cameras[0] as Camera3D)
	if player_camera == null:
		return
	brightness_slider.ratio = inverse_lerp(brightness_min, brightness_max, player_camera.environment.background_energy_multiplier)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and !$AnimationPlayer.is_playing():
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			get_tree().paused = true
			$AnimationPlayer.play("show")
		else:
			get_tree().paused = false
			$AnimationPlayer.play("hide")


func set_mouse_visible():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func set_mouse_captured():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	scroll_background.texture.noise.offset.x += delta * scroll_speed
	scroll_background.texture.noise.offset.x = fmod(
		scroll_background.texture.noise.offset.x,
		scroll_background.texture.width
	)

func _on_master_volume_changed(value):
	var index = AudioServer.get_bus_index("Master")
	if(value == master_volume_slider.min_value):
		AudioServer.set_bus_mute(index, true)
		return
	AudioServer.set_bus_mute(index, false)
	AudioServer.set_bus_volume_db(index, lerpf(volume_min, volume_max, master_volume_slider.ratio));

func _on_brightness_changed(value):
	if player_camera == null:
		return
	player_camera.environment.background_energy_multiplier = lerpf(brightness_min, brightness_max, brightness_slider.ratio)
	#player_camera.environment.tonemap_exposure = value
