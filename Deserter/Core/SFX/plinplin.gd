extends AudioStreamPlayer

@onready var t = $t

func _on_t_timeout() -> void:
	pitch_scale=randf_range(0.7,1.3)
	play()
	t.start(randf_range(0.2,5.0))
