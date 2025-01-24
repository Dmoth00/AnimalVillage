extends Node3D

@onready var cam= $Cam
@onready var sky= $skyMesh.get_active_material(0)

func _process(delta: float) -> void:
	cam.global_position.y=lerpf(cam.global_position.y,-6,delta/8)
	sky.uv1_offset.y+=delta/32
	pass
