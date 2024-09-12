extends Node

@export var active: bool = true

var rand_low_secs = 0.2
var rand_high_secs = 2

var timer: Timer


func _ready() -> void:
	if not "visible" in self:
		return
	
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true
	var time = randf_range(rand_low_secs, rand_high_secs)
	timer.start(time)


func _on_timer_timeout() -> void:
	if active:
		set("visible", not get("visible"))
	timer.start(randf_range(rand_low_secs, rand_high_secs))
