extends CharacterBody3D

#enemyvars
@export var health = 1.0
@export var damage = 0.0
@export var alertDistance = 6.0
@export var maxVelocity = 4.0
@export var knockdown = false
@export var attack = false

var vel = 0.0
var state : int = 0
var dir = Vector3.ZERO
var ldir = Vector3.FORWARD

@onready var target = null

var dis : float = 0.0

@onready var mesh = $SpiderArm/Skeleton3D/SpiderMesh
@onready var anim = $anim

@onready var id = ""

func _process(delta):
	
	if target!=null:
		dis=global_position.distance_to(target.global_position)
		if dis>0.3 && dis<alertDistance && target.fl:
		#accel
			vel=min(vel+maxVelocity*delta/2,maxVelocity)
		#direction to go
			dir = NewFunc.flat(target.global_position-global_position).normalized()
			if attack==false: dir*=-1
		#turns to where its going
			ldir=ldir.slerp(dir,delta*10)
			look_at(global_position-ldir-gvars.wigl,Vector3.UP)
		else:
		#deaccel
			vel=max(vel-maxVelocity*delta*4,0.0)

func _physics_process(delta):
	
		#actual movement
	if not is_on_floor():
		velocity.y -= gvars.gravity * delta
	velocity.x=ldir.x*vel
	velocity.z=ldir.z*vel
	
	move_and_slide()
		
	#walk animation
	anim.speed_scale=velocity.length()

func _hurt(dmg : float):
	vel=0
	health -= dmg
	gvars.hatred+=0.01
	
func _on_re_target() -> void:
	target=NewFunc.nearest_in_group("Player",transform.origin)
	pass # Replace with function body.
