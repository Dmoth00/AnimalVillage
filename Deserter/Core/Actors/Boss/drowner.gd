extends CharacterBody3D

@onready var anim=$drowner/AnimationPlayer
@onready var mesh=$drowner/ArmDrown
@onready var air=$air

@onready var sfx_hit=$drowner/ArmDrown/Skeleton3D/BoneHead/bloodSFX
@onready var sfx_splash=$sfx_splash

@onready var deathFlag : Signal

@export var health : int = 6
var vul = false

var state=0
var t = 0.0
var speed = 6.0

var dir=basis.z
var ldir=basis.z

var setup=false
var emerge_ok=true

var target : Node3D
var tarpos : Vector3

func _process(delta: float) -> void:
	match state:
		0:#crawling underwater
			if !setup:
				t=0.0
				air.start(3.0)
				anim.play("ArmDrownCrawl",0.1,3.0)
				setup=true
			ldir=NewFunc.flat(ldir.rotated(Vector3.UP,ldir.signed_angle_to(dir,Vector3.UP)*delta*8)).normalized()
			look_at(global_position-ldir)
			t+=delta
			if t>0.2:
				t=0.0
				dir=dir.rotated(Vector3.UP,deg_to_rad(5))
		1:#emerging
			if !setup:
				t=0.0
				anim.play("ArmDrownRise",0.5)
				sfx_splash.restart()
				setup=true
			t+=delta
			if t>1.25:
				state=2
				anim.play("ArmDrownStand")
				vul=true
				air.start(randf_range(2.0,5.0))
				setup=false
		2:#standing there menacingly
			dir = NewFunc.flat(tarpos-global_position).normalized()
			ldir=NewFunc.flat(ldir.rotated(Vector3.UP,ldir.signed_angle_to(dir,Vector3.UP)*delta*4)).normalized()
			look_at(global_position-ldir)
		3:#submerging
			if !setup:
				anim.play("ArmDrownDive",0.5)
				sfx_splash.restart()
				t=0.0
				setup=true
			t+=delta
			if t>1.25:
				state=0
				setup=false
		4: #I'm hit!
			if !setup:
				setup=true
				t=0.0
				anim.play("ArmDrownHit",0.1)
			t+=delta
			if t>2:
				setup=false
				state=3
		5: #is this.... death?
			if !setup:
				setup=true
				deathFlag.emit()
				t=0.0
				anim.play("ArmDrownDeath",0.1)
			t+=delta
			if t>2.5:
				mesh.scale.y=5-t
			if t>5.0:
				queue_free()


func _physics_process(delta: float) -> void:
	
	match state:
		0: #crawling underwater
			var col= move_and_collide(delta*dir*speed)
			if col: dir=dir.bounce(col.get_normal())

func _on_seek_player_timeout() -> void:
	target=NewFunc.nearest_in_group("Player",transform.origin)
	if target:
		tarpos=target.global_position
	pass # Replace with function body.

func _on_air_timeout() -> void:
	match state:
		0:
			if emerge_ok:
				setup=false
				state=1
			else:
				air.start(1.0)
		2:
			state=3
			setup=false
			vul=false

func _on_emerge_ok_area_entered(_area: Area3D) -> void: emerge_ok=false
func _on_emerge_ok_area_exited(_area: Area3D) -> void: emerge_ok=true


func hurt(_damage : float):
	if vul:
		vul=false
		health-=1
		setup=false
		sfx_hit.restart()
		if health>0: state=4
		else: state=5
		
