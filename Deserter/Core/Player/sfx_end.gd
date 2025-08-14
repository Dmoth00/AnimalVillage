extends GPUParticles3D

func _on_finished() -> void:
	print("smoke")
	queue_free()
	pass # Replace with function body.
