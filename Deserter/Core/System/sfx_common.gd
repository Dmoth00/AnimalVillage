extends GPUParticles3D

func _on_finished() -> void: queue_free()

func act():
	var snd=get_node("snd")
	if snd: snd.play()
	restart()
