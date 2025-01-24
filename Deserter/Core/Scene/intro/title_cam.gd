extends Node3D

@onready var cam=$cam
@onready var sky=$skyMesh.get_active_material(0)
@onready var sun=$sun
@onready var env=$env
@onready var bun=$bun
@onready var tit1=$tit/title_mesh.get_active_material(0)
@onready var tit2=$tit/title_mesh00.get_active_material(0)

var t=0.0

func _ready() -> void:
	cam.global_position.y=3.0
	env.environment.ambient_light_energy=5
	bun.global_position.z=-12
	tit2.albedo_color.a=0.0
	tit1.albedo_color.a=0.0
	sky.albedo_color.a=1.0


func _process(delta: float) -> void:
	t+=delta
	
	cam.global_position.y=lerpf(cam.global_position.y,-10,delta/16)
	sky.uv1_offset.y+=delta/32
	if sun.rotation_degrees.x<15: sun.rotate_x(delta/12)
	env.environment.ambient_light_energy=lerpf(env.environment.ambient_light_energy,0.2,delta/12)
	
	if t>12:
		tit1.albedo_color.a=min(tit1.albedo_color.a+delta/8,1)
	
	if t>24:
		bun.global_position.z=lerpf(bun.global_position.z,-1.5,delta*2)
		sky.albedo_color.a-=delta*32
	
	if t>28: tit2.albedo_color.a=min(tit2.albedo_color.a+delta/16,1)
	
	if t>60:
		set_process(false)
		print("intro end!")
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("db_restart"): gvars.reset()
