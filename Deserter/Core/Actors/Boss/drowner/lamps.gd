extends Node3D

func _ready() -> void:
	set_process(false)
	pass

func _process(delta: float) -> void:
	rotate(Vector3.UP,delta/4)

func act():
	set_process(!is_processing())
