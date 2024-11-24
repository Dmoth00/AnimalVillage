extends MeshInstance3D

@onready var seen = false
@onready var mat = self.get_surface_override_material(0)
var t=1.0
var n=0

func _process(delta: float) -> void:
	if seen: n=1
	else: n=-1
	t=clampf(t+4*delta*n,0.0,1.0)
	mat.set_shader_parameter("alpha",t)
	pass
