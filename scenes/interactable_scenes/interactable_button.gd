extends Interactable



func _on_interacted(_body) -> void:
	$AudioStreamPlayer3D.play()
