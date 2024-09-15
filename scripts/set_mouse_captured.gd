extends Control


var mouse_over: bool = false

func _input(event):
	if event.is_action_pressed("click"):
		if mouse_over and not UserSettings.is_paused:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
