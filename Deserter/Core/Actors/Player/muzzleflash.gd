extends MeshInstance3D

@onready var mat= get_surface_override_material(0)
@onready var col= Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	col.a=0.0
	mat.albedo_color=col

func act():
	col.a=1.0
	process_mode=PROCESS_MODE_INHERIT

func _process(delta: float) -> void:
	if col.a>0.0:
		col.a = max(col.a-delta*4,0)
		scale.z = col.a
		mat.albedo_color= col
	else: process_mode=PROCESS_MODE_DISABLED
