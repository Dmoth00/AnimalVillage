extends Node3D
var t :float

func _ready() -> void:
	t=randf_range(0.0,2*PI)

func _physics_process(delta: float)-> void:
	t= fmod(t+delta*0.5,2*PI)
	global_position.y = sin(t)
	pass
