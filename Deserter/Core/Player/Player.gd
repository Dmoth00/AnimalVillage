extends CharacterBody3D

const SPEED = 4.0
var runMod = 1.0

var state=0
var can_move=true

#gun variables
var can_shoot=false
var aiming=false
var firet=0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var mesh=get_node("CharArm")
@onready var anim=get_node("anim")
var direction=Vector3.ZERO
var input_dir=Vector2.ZERO
var ldir=Vector3.BACK


#flashlight stuff
var fl=true
@onready var fl_l=$CharArm/Skeleton3D/fl/fl_light
@onready var fl_shad=$CharArm/Skeleton3D/fl/fl_shad
@onready var fl_mat=$CharArm/Skeleton3D/charMesh.get_surface_override_material(3)
@onready var fl_spot=$fl_spot
@onready var fl_glare=$CharArm/Skeleton3D/fl/fl_glare

func _physics_process(delta):
	
	# fall detection
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Input detection for direction
	input_dir = Input.get_vector("gp_left", "gp_right", "gp_up", "gp_down").normalized()
	direction = Vector3(input_dir.x,0,input_dir.y)
	
	#voluntary movement
	if direction and state==0:
		velocity.x = direction.x * SPEED*runMod
		velocity.z = direction.z * SPEED*runMod
	#deacceleration
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func _process(delta):
	
	#face direction
	if direction:
		direction=(direction+Vector3(0.01,0,0.01)).normalized()
		ldir=ldir.slerp(direction,delta*10).normalized()
		mesh.look_at(transform.origin+ldir)
	
	match state:
		0:
			#animation for movement
			if velocity.length()>SPEED: anim.play("CharAnim_Run",0.5,1.3)
			else: if velocity.length()>0: anim.play("CharAnim_Walk",0.5,1.5)
			else: anim.play("CharAnim_Stand",0.5,1.0)
			
			#aim engaged
			if aiming:
				state=1
				anim.play("CharAnim_Aim",0.5,1.5)
		1:
			#shoot timer
			if aiming:
				firet=min(1,firet+delta*2)
				if firet==1:
					can_shoot=true
			#un-aim
			else:
				state=0
				can_shoot=false
				firet=0.0

func _input(event):
	if can_move:
		#flashlight input
		if event.is_action_pressed("gp_fl"): flashlight()
		
		#run input
		if event.is_action_pressed("gp_run"): runMod=1.8
		if event.is_action_released("gp_run"): runMod=1.0
		
		#aim input
		if event.is_action_pressed("gp_aim"): aiming=true
		if event.is_action_released("gp_aim"): aiming=false
		
		#fire imput
		if event.is_action_pressed("gp_fire"): shoot()

func shoot():
		if can_shoot:
			firet=0.0
			anim.play("CharAnim_Shoot",0.1,1)

func flashlight():
	if fl:
		fl_l.light_energy=0
		fl_shad.light_energy=0
		fl_spot.light_energy=0.1
		fl_mat.emission_energy_multiplier=0
		fl_glare.visible=false
		fl=false
	else:
		fl_l.light_energy=3
		fl_shad.light_energy=0.1
		fl_spot.light_energy=0.5
		fl_mat.emission_energy_multiplier=1
		fl_glare.visible=true
		fl=true
	pass
