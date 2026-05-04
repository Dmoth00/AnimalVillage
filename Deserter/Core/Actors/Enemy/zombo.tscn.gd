extends CharacterBody3D

#enemyvars
@export var health = 3.0
@export var damage = 0.8
@export var alertDistance = 6.0
@export var maxVelocity = 1.5


var vel = 0.0
var state : int = 0
@onready var dir = NewFunc.flat(transform.basis.z)
@onready var ldir = NewFunc.flat(transform.basis.z)

@onready var target = null
@onready var re_target = $re_target

var dis : float = 0.0

@onready var mesh = $ZombArm/Skeleton3D/ZombMesh
@onready var anim = $anim

#id for death & ressurection
@onready var id : String
##do not ressurect?
@export var dnr : bool = false

func _process(delta):
	#turns to where its going
	ldir=NewFunc.flat(ldir.rotated(Vector3.UP,ldir.signed_angle_to(dir,Vector3.UP)*delta*10)).normalized()
	look_at(global_position-ldir)
	
	if target!=null:
		dis=global_position.distance_to(target.global_position)
		if dis>0.3 && dis<alertDistance && target.fl:
		#accel
			vel=min(vel+maxVelocity*delta/2,maxVelocity)
		#direction to go
			dir = NewFunc.flat(target.global_position-global_position).normalized()
		else:
		#deaccel
			vel=max(vel-maxVelocity*delta*4,0.0)
	
		#walk animation
	if vel>0.5: anim.play("ZombAnim/ZombAnimWalk",1.0)
	else: anim.play("ZombAnim/ZombAnimStand",1.0)

func _physics_process(delta):
	
	#actual movement
	if not is_on_floor():
		velocity.y -= gvars.gravity * delta
	velocity.x=ldir.x*vel
	velocity.z=ldir.z*vel
	
	move_and_slide()
	


func _hurt(dmg : float):
	health -= dmg
	gvars.hatred+=randf_range(0.1,0.2)
	gvars.bloodBag+=(1+gvars.hatred)*0.1
	var bld=get_node("bloodSFX").duplicate()
	get_tree().get_first_node_in_group("GM").add_child(bld)
	bld.global_transform=global_transform
	bld.act()
	if health>0:
		vel=-12.0
		target=null
		re_target.start(1.0)
	else:
		get_tree().get_first_node_in_group("Player").get_node("bloodGet").restart()
		if dnr: gvars.event_list.append(id)
		else: gvars.kill_list.append(id)
		print(str(id)+" has died.")
		call_deferred("queue_free")

func _on_re_target() -> void:
	re_target.wait_time=0.2
	target=NewFunc.nearest_in_group("Player",transform.origin)
