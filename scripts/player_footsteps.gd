extends AudioStreamPlayer3D

@export var volume_low: float = -10
@export var volume_high: float = 0

func set_high():
	volume_db = volume_high

func set_low():
	volume_db = volume_low
