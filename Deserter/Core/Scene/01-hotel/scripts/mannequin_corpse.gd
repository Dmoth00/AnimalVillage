extends MeshInstance3D

func _ready() -> void: set_process(false)

func act():
	print("acting")
	set_process(true)

func _process(delta: float) -> void:
	scale.y+=delta
	if scale.y>scale.x: set_process(false)
	pass
