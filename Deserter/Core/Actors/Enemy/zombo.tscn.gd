extends CharacterBody3D

#enemyvars
@export var health = 3.0
@export var damage = 0.8
@export var alertDistance = 8.0
@export var maxVelocity = 1.5


var vel = 0.0
var state : int = 0
@onready var dir = NewFunc.flat(transform.basis.z)
@onready var ldir = NewFunc.flat(transform.basis.z)

@onready var target = null
@onready var tarpos = global_position
@onready var re_target = $re_target

var dis : float = 0.0

@onready var mesh = $ZombArm/Skeleton3D/ZombMesh
@onready var anim = $anim

#id for death & ressurection
@onready var id : String
##do not ressurect?
@export var dnr : bool = false

@onready var go : bool = false

func _process(delta):
	if state==0:
		if go:
		
			#direction to go
			dir = NewFunc.flat(tarpos-global_position).normalized()
			#turns to where its going
			ldir=NewFunc.flat(ldir.rotated(Vector3.UP,ldir.signed_angle_to(dir,Vector3.UP)*delta*10)).normalized()
			look_at(global_position-ldir)
			#accel
			vel=min(vel+delta/2,maxVelocity)
		else:
			#deaccel
			vel=max(vel-delta*6,0)
			#walk animation
		if vel>0.1:
			anim.play("ZombAnim/ZombAnimWalk",1.0,vel)
		else: anim.play("ZombAnim/ZombAnimStand",1.0,1.0)
	else:
		vel=max(vel-delta*24,0)

func _physics_process(delta):
	
	#actual movement
	if not is_on_floor():
		velocity.y -= gvars.gravity * delta * 8
	velocity.x=ldir.x*vel
	velocity.z=ldir.z*vel
	
	move_and_slide()
	


func _hurt(dmg : float):
	if state!=0: return
	health -= dmg
	gvars.hatred+=randf_range(0.1,0.2)
	gvars.bloodBag+=(1+gvars.hatred)*0.1
	var bld=get_node("bloodSFX").duplicate()
	get_tree().get_first_node_in_group("GM").add_child(bld)
	bld.global_transform=global_transform
	bld.act()
	if health>0:
		anim.play("ZombAnim/ZombAnimHurt")
		vel=-12.0
		target=null
		re_target.start(1.0)
		state=1
	else:
		get_tree().get_first_node_in_group("Player").get_node("bloodGet").restart()
		if dnr: gvars.event_list.append(id)
		else: gvars.kill_list.append(id)
		print(str(id)+" has died.")
		call_deferred("queue_free")

func _on_re_target() -> void:
	state=0
	re_target.wait_time=0.2
	target=NewFunc.nearest_in_group("Player",transform.origin)
	
	if target==null: go=false
	else:
		var adis = alertDistance
		if !target.fl: adis*=0.5
		tarpos=target.global_position
		dis=global_position.distance_to(tarpos)
		if dis>0.3 && dis<adis:
			go=true
		else: go=false
