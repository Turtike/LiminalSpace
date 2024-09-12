extends RayCast3D

@onready var prompt = $Prompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	prompt.text = ""

	if is_colliding():
		var collider = get_collider()
		
		if collider is Interactable:
			prompt.text = collider.prompt_msg
			
			if Input.is_action_just_pressed("interact"):
				collider.interact(owner)
	
	pass
