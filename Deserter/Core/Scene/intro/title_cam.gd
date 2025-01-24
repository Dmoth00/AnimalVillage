extends Node3D

@onready var cam=$cam
@onready var sky=$skyMesh.get_active_material(0)
@onready var sun=$sun
@onready var env=$env
@onready var bun=$bun

var t=0.0

func _ready() -> void:
	cam.global_position.y=3.0
	env.environment.ambient_light_energy=5
	bun.global_position.z=-12

func _process(delta: float) -> void:
	cam.global_position.y=lerpf(cam.global_position.y,-10,delta/16)
	sky.uv1_offset.y+=delta/32
	if sun.rotation_degrees.x<15: sun.rotate_x(delta/12)
	env.environment.ambient_light_energy=lerpf(env.environment.ambient_light_energy,0.2,delta/12)
	
	
	if t<24: t+=delta
	else:
		bun.global_position.z=lerpf(bun.global_position.z,-1.5,delta*2)
		sky.albedo_color.a-=delta*32
	pass
