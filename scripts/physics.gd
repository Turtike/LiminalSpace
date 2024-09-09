extends Node


func set_gravity_vector(vect: Vector3) -> void:
	PhysicsServer3D.area_set_param(\
		get_viewport().find_world_3d().space,\
		PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, vect)
