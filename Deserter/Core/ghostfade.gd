extends MeshInstance3D


var t=1.0
var n=0
@onready var seen = false
@onready var mat

@onready var id = ""

func _ready() -> void:
	mat = self.get_surface_override_material(0)

func _process(delta: float) -> void:
	if seen: n=1
	else: n=-1
	t=clampf(t+2*delta*n,0.0,1.0)
	mat.set_shader_parameter("alpha",t)
	pass
