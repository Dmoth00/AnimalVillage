extends Node3D

@onready var player
@onready var target = global_position
@onready var offset = Vector3.ZERO
@onready var off_input = Vector2.ZERO
@onready var cam = $cam


var camdist
var camangl
var camoff = Vector2.ZERO

#GUI stuff
@onready var db_sign=$GUI/db_text
@onready var fade=$GUI/fade

func _ready() -> void:
	db_sign.visible=gvars.debug_mode
	get_player()
	reset_cam()
	fade_in(0.5)
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	
	#check if player is there
	if player!=null:
		target=player.global_position
	
	#Check offset input
	off_input = Input.get_vector("gp_rleft", "gp_rright", "gp_rup", "gp_rdown")
	offset = Vector3(off_input.x,0,off_input.y)*2
	
	#adjust camera accordingly
	#position
	global_position=global_position.lerp(target+offset,delta*12)
	#rotation
	rotation.x=move_toward(rotation.x,deg_to_rad(camangl),delta/2)
	#zoom
	cam.position=cam.position.lerp(Vector3(camoff.x,camoff.y,camdist),delta*2)
	
func _input(event: InputEvent) -> void:
	
	#debug mode and actions
	if event.is_action_pressed("db_toggle"):
		gvars.debug_mode=!gvars.debug_mode
		db_sign.visible=gvars.debug_mode
		
	
	if gvars.debug_mode:
		#restart game
		if event.is_action_pressed("db_restart"): gvars.reset()
	
		#camera adjust
		if event.is_action_pressed("cam_angle+"): camangl+=5
		if event.is_action_pressed("cam_angle-"): camangl-=5
		if event.is_action_pressed("cam_zoom+"): camdist-=0.25
		if event.is_action_pressed("cam_zoom-"): camdist+=0.25
		
		#camera reset
		if event.is_action_pressed("cam_reset"): reset_cam()
	pass

func get_player(): player = get_tree().get_nodes_in_group("Player")[0]

func reset_cam():
	camdist = 6.0
	camangl = -60.0
	camoff = Vector2.ZERO
	

func fade_out (t : float):
	fade.color.a=0.0
	fade.inc=t
	fade.set_process(true)

func fade_in (t : float):
	fade.color.a=1.0
	fade.inc=t*-1
	fade.set_process(true)
