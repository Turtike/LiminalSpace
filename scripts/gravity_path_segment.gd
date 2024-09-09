@tool
class_name GravityPathSegment
extends Area3D


func set_size(size: Vector3) -> void:
	$CollisionShape3D.shape.size = size
	$MeshInstance3D.mesh.size = size


func _on_body_entered(body: Node3D) -> void:
	if body is GravityCharacterBody3D:
		var tween = body.create_tween()
		tween.tween_property(body, "up_direction", transform.basis.y, 0.3)
