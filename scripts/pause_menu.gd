extends Control

@export var scroll_background: TextureRect
@export var master_volume_slider: HSlider
@export var volume_min: float = -50.0
@export var volume_max: float = 50.0

var scroll_speed: float = 5

func _ready() -> void:
	master_volume_slider.ratio = inverse_lerp(volume_min, volume_max, master_volume_slider.ratio)

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
