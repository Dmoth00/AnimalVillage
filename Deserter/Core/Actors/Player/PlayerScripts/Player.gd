extends CharacterBody3D

const SPEED = 3.0
var runMod = 1.0
var gravity= ProjectSettings.get_setting("physics/3d/default_gravity")

var state=2
@onready var inputOff=false
var can_move=false

#gun variables
var can_shoot=false
var aiming=false
var firet=0.5
@onready var muzzle=$CharArm/muzzleflash
@onready var smoke=$smokeSFX
@onready var hit_sfx=$CharArm/bloodSFX
@onready var gunray=$CharArm/gunRay


#movement collision and animation
@onready var mesh=get_node("CharArm")
@onready var anim=get_node("anim")
@onready var col=get_node("collision/col")
var direction=Vector3.ZERO
var input_dir=Vector2.ZERO
var ldir=Vector3.BACK
var ltgt=Vector3.BACK

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
@onready var death_timer=$death_timer
var bldt = 0.0

#sounds
@onready var snd_step=$anim/sndStep
@onready var snd_shoot=$anim/sndShoot
@onready var snd_reload=$anim/sndReload
@onready var snd_hit=$anim/sndHit
@onready var snd_click=$anim/sndClick
@onready var sfx=$SFX

#actionable variables
var interactables : Array
@onready var act_sign=$act_sign

#when you walkin
var in_water=false

#miscelaneous variables
var t=0.0


#main processes

func _ready() -> void:
	set_floor_snap_length(1.0)
	flashlight(true)
	anim.play("CharAnim_Awake",1,1)
	awake_timer.start(5.0)

func _physics_process(delta):
	
	# fall detection
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Input detection for direction
	
	if !inputOff: input_dir = Input.get_vector("gp_left", "gp_right", "gp_up", "gp_down")
	else: input_dir =Vector3.ZERO
	
	direction = Vector3(input_dir.x,0,input_dir.y)
	
	#voluntary movement
	if direction.length()>0.5 and state==0:
		velocity.x = direction.x*SPEED*runMod
		velocity.z = direction.z*SPEED*runMod
	#deacceleration
	else:
		velocity.x = move_toward(velocity.x,0,16*delta)
		velocity.z = move_toward(velocity.z,0,16*delta)
	
	#movement finalization
	move_and_slide()
	
	#blood ministration
	if state==0 and can_move and !inputOff:
		if gvars.blood<gvars.bloodMax and gvars.bloodBag>0.0:
			bldt+=delta
			if bldt>=6.0:
				bldt=4.0
				gvars.bloodBag=max(gvars.bloodBag-0.2,0.0)
				gvars.blood=min(gvars.bloodMax,gvars.blood+0.2)
	else: bldt=0.0

func _process(delta):
	
	#face direction
	if direction and can_move: ltgt=direction
	if ldir!=ltgt:
			ldir=ldir.rotated(Vector3.UP,ldir.signed_angle_to(ltgt,Vector3.UP)*delta*10).normalized()
			ldir=NewFunc.flat(ldir)
			mesh.look_at(global_position+ldir)
	
	match state:
		0:
			#animation for movement
			if velocity.length()>4.0: anim.play("CharAnim_Run",0.5,1.3)
			else: if velocity.length()>0: anim.play("CharAnim_Walk",0.5,1.7)
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
			if can_move: state=0
			#AWAKE ANIM
	
	#interact sign
	if !inputOff and state==0 and interactables.size()>0:
		act_sign.scale=act_sign.scale.lerp(Vector3.ONE,delta*12)
	else: act_sign.scale=act_sign.scale.lerp(Vector3.ZERO,delta*12)

func _input(event):
	
	#run input
	if event.is_action_pressed("gp_run"): runMod=2.5
	if event.is_action_released("gp_run"): runMod=1.0
	
	if inputOff: return
	
	if can_move:
		#flashlight input
		if event.is_action_pressed("gp_fl"): flashlight()
		#action input
		if event.is_action_pressed("gp_activate"): _act()
		
		if can_shoot:
			#fire imput
			if event.is_action_pressed("gp_fire"): _shoot()
			#reload imput
			if event.is_action_pressed("gp_reload"): _reload()
	
	
	#aim input
	if event.is_action_pressed("gp_aim"): aiming=true
	if event.is_action_released("gp_aim"): aiming=false

#actions

func _act():
	if interactables.size()>0 and state==0:
		interactables[0].act(self)

func _shoot():
		if gvars.gun>0:
			#remove the bullet
			gvars.gun-=1
			#muzzle flash
			muzzle.act()
			fl_shad.flash()
			#smoke from the barrel
			var smoke_dupe=smoke.duplicate()
			add_child(smoke_dupe)
			smoke_dupe.look_at_from_position(muzzle.global_position,muzzle.global_position+ldir,Vector3.UP)
			smoke_dupe.restart()
			#recoil
			can_move=false
			firet=0.5
			anim.play("CharAnim_Shoot",0.1,1)
			#bang
			snd_shoot.play()
			#and now we check if it hits
			if gunray.is_colliding():
				var hit=gunray.get_collider()
				if hit.is_in_group("Mortal"): hit._hurt(1.0+gvars.hatred/100)
		else: snd_click.play()

func _reload():
		if gvars.bullets>0 and gvars.gun<gvars.chamber:
			can_move=false
			firet=1.0
			anim.play("CharAim_Reload",0.1,1)
			snd_reload.play()
			var empt=gvars.chamber-gvars.gun
			if gvars.bullets>empt:
				gvars.bullets-=empt
				gvars.gun=gvars.chamber
			else:
				gvars.gun+=gvars.bullets
				gvars.bullets=0

func flashlight(mute = false):
	if !mute: snd_click.play()
	if fl:
		#these are all visual
		fl_l.light_energy=0
		fl_shad.act(false)
		fl_mat.emission_energy_multiplier=0
		fl_glare.visible=false
		#this affects ghost detection range
		set_deferred("gDetect.disabled",true)
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

func _death():
	print("Death.")
	remove_from_group("Player")
	anim.play("CharAnim_KnockDown")
	fl=true
	flashlight()
	gDetect.get_parent().unsee_all()
	death_timer.start(5.0)

func _hurt(other : Node3D):
	gvars.blood=max(gvars.blood-other.damage,0.0)
	gvars.hatred+=randf_range(0.1,other.damage+0.1)
	print(gvars.blood)
	snd_hit.play()
	hit_sfx.restart()
	state=2
	can_move=false
	col.set_deferred("disabled",true)
	var tgt_temp = other.global_position
	tgt_temp.y=global_position.y
	mesh.look_at(tgt_temp)
	ldir=(other.global_position-global_position).normalized()
	var d = other.global_position.direction_to(global_position)
	var hspd = 12
	velocity.x=d.x*hspd
	velocity.z=d.z*hspd
	
	if gvars.blood==0: _death()
	else:
		print("Ouch!")
		if other.knockdown:
			can_move_timer.start(2.0)
			vul_timer.start(4.0)
			anim.play("CharAnim_KnockDown")
		else:
			can_move_timer.start(1.0)
			vul_timer.start(3.0)
			anim.play("CharAnim_Hurt")

func step():
	if is_on_floor():
		if in_water:
			snd_step.stream=load("res://Assets/Sounds/SFX/snd_stepWater.wav")
		else:
			snd_step.stream=load("res://Assets/Sounds/SFX/snd_step2.wav")
		snd_step.pitch_scale=0.5+randf()
		snd_step.play()

#collisions

func _on_collision_body_entered(body: Node3D) -> void:
	if body.is_in_group("Harm"): _hurt(body)
	if body.is_in_group("Item"): body.act()

func _on_act_detect_in(area: Node3D) -> void:
	if area.is_in_group("Act"): interactables.push_back(area)

func _on_act_detect_out(area: Node3D) -> void:
	if interactables.has(area): interactables.erase(area)

#timers

func _on_can_move_timer() -> void: can_move=true

func _on_vul_timer() -> void: col.disabled=false

func _on_awake_timer() -> void:
	can_move=true
	vul_timer.start(0.25)
	flashlight()

func _on_death_timer() -> void: gvars.reset()
