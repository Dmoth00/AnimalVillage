extends MeshInstance3D

@export var primaryColor : Color = Color.CRIMSON
@export var secondaryColor : Color = Color.BROWN

@onready var mat : Material

var t = 0.0

var col1 : Color
var col2 : Color

var pcol : Color
var scol : Color

func _ready() -> void:
	mat = self.get_surface_override_material(0).duplicate(false)
	self.set_surface_override_material(0,mat)
	set_process(false)
	
	pcol=mat.get_shader_parameter("primary_color")
	scol=mat.get_shader_parameter("secondary_color")

func _process(delta: float) -> void:
	t=min(t+delta/5,1.0)
	mat.set_shader_parameter("water_transparency",0.4*(1.0-t))
	col1=pcol.lerp(primaryColor,t)
	col2=scol.lerp(secondaryColor,t)
	mat.set_shader_parameter("primary_color",col1)
	mat.set_shader_parameter("secondary_color",col2)
	if t==1.0: set_process(false)

func act(): set_process(true)
