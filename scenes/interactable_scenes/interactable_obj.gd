extends CollisionObject3D
class_name Interactable

signal interacted(body)


@export var prompt_msg = "Press E to interact"

func interact(body):
	#print(body.name, " interacted with ", name)
	
	interacted.emit(body)
