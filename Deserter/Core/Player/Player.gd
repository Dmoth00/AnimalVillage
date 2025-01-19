extends CharacterBody3D

const SPEED = 4.0
var runMod = 1.0

var state=2
var can_move=false


#gun variables
var can_shoot=false
var aiming=false
var firet=0.5
@onready var muzzle=$CharArm/muzzleflash
@onready var smoke=$smokeSFX

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var mesh=get_node("CharArm")
@onready var anim=get_node("anim")
@onready var col=get_node("collision/col")
var direction=Vector3.ZERO
var input_dir=Vector2.ZERO
var ldir=Vector3.BACK


#flashlight stuff
var fl=true
@onready var gDetect=$CharArm/GhostDetect/col
@onready var fl_l=$CharArm/Skeleton3D/fl/fl_light
@onready var fl_shad=$CharArm/fl_shad
@onready var fl_mat=$CharArm/Skeleton3D/charMesh.get_surface_override_material(3)
@onready var fl_glare=$CharArm/Skeleton3D/fl/fl_glare

#timers
@onready var awake_timer=$awake_timer
@onready var vul_timer=$vul_timer
@onready var can_move_timer=$can_move_timer

#miscelaneous variables
var t=0.0

func _ready() -> void:
	flashlight()
	anim.play("CharAnim_Awake",1,1)
	awake_timer.start(5.0)

func _physics_process(delta):
	
	# fall detection
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	
	# Input detection for direction
	input_dir = Input.get_vector("gp_left", "gp_right", "gp_up", "gp_down").normalized()
	direction = Vector3(input_dir.x,0,input_dir.y)
	
	#voluntary movement
	if direction and state==0:
		velocity.x = direction.x * SPEED*runMod
		velocity.z = direction.z * SPEED*runMod
	#deacceleration
	else:
		velocity.x = move_toward(velocity.x, 0, 32*delta)
		velocity.z = move_toward(velocity.z, 0, 32*delta)
	
	move_and_slide()

func _process(delta):
	
	#face direction
	if direction and can_move:
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
			firet=max(0,firet-delta)
			if firet==0:
				can_move=true
				if aiming:
					can_shoot=true
				#un-aim
				else:
					state=0
					can_shoot=false
					firet=0.5
		2:
			if can_move:
				state=0
			pass
			#AWAKE ANIM

func _input(event):
	if can_move:
		#flashlight input
		if event.is_action_pressed("gp_fl"): flashlight()
		
		#fire imput
		if event.is_action_pressed("gp_fire"): _shoot()
		
		#reload imput
		if event.is_action_pressed("gp_reload"): _reload()
		
	#run input
	if event.is_action_pressed("gp_run"): runMod=1.8
	if event.is_action_released("gp_run"): runMod=1.0
	
	#aim input
	if event.is_action_pressed("gp_aim"): aiming=true
	if event.is_action_released("gp_aim"): aiming=false

func _shoot():
		if can_shoot:
			muzzle.act()
			smoke.look_at_from_position(muzzle.global_position,muzzle.global_position+ldir,Vector3.UP)
			smoke.restart()
			fl_shad.flash()
			can_move=false
			firet=0.5
			anim.play("CharAnim_Shoot",0.1,1)

func _reload():
		if can_shoot:
			can_move=false
			firet=1.0
			anim.play("CharAim_Reload",0.1,1)

func flashlight():
	if fl:
		#these are all visual
		fl_l.light_energy=0
		fl_shad.act(false)
		fl_mat.emission_energy_multiplier=0
		fl_glare.visible=false
		#this affects ghost detection range
		gDetect.disabled=true
		#and set the flashlight to off
		fl=false
	else:
		fl_l.light_energy=15
		fl_shad.act(true)
		fl_mat.emission_energy_multiplier=1
		fl_glare.visible=true
		#this affects ghost detection range
		gDetect.disabled=false
		#and set the flashlight to on
		fl=true
	pass

func _hurt(other : Node3D):
	print("Ouch!")
	state=2
	can_move=false
	can_move_timer.start(1.0)
	col.set_deferred("disabled",true)
	vul_timer.start(3.0)
	anim.play("CharAnim_Hurt")
	mesh.look_at(other.global_position)
	ldir=(other.global_position-global_position).normalized()
	var d = other.global_position.direction_to(global_position)
	var hspd = 12
	velocity.x=d.x*hspd
	velocity.z=d.z*hspd
	pass

func _on_collision_body_entered(body: Node3D) -> void:
	if body.is_in_group("Harm"):
		_hurt(body)
		pass
	pass # Replace with function body.

#timers

func _on_can_move_timer() -> void: can_move=true

func _on_vul_timer() -> void:
	col.disabled=false
	print("Vulnerable")

func _on_awake_timer() -> void:
	can_move=true
	vul_timer.start(0.25)
	flashlight()
	pass # Replace with function body.
