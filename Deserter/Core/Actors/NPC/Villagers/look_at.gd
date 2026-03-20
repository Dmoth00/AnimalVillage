extends LookAtModifier3D

func _on_eyes_area_body_entered(body: Node3D) -> void:
	target_node=body.get_path()
	pass # Replace with function body.

func _on_eyes_area_body_exited(_body: Node3D) -> void:
	target_node=""
	pass # Replace with function body.
