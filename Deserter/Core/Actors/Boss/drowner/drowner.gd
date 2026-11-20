extends CharacterBody3D

@onready var anim=$drowner/AnimationPlayer
@onready var mesh=$drowner/ArmDrown
@onready var air=$air

@onready var sfx_hit=$drowner/ArmDrown/Skeleton3D/BoneHead/bloodSFX
@onready var sfx_splash=$sfx_splash
@onready var sfx_death=$drowner/ArmDrown/Skeleton3D/BoneChest/BleedOut
@onready var bubbler=$drowner/ArmDrown/Skeleton3D/BoneHead/bubbleEmitter

@onready var snd_splash=$snd_splash
@onready var snd_hit=$snd_hit
@onready var snd_voice=$snd_voice

@export var voices : Array[AudioStream]

signal deathFlag

@export var health : int = 6
var vul = false

var attack = false

var state=7
var t = 0.0
var speed = 6.0

var dir=basis.z
var ldir=basis.z
var tvec : Vector3

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
			looker(delta,4)
			t+=delta
			if t>0.2:
				t=0.0
				dir=dir.rotated(Vector3.UP,deg_to_rad(5))
		1:#emerging
			if !setup:
				t=0.0
				anim.play("ArmDrownRise",0.5)
				sfx_splash.restart()
				snd_splash.play()
				setup=true
			t+=delta
			if t>1.25:
				t=0.0
				state=2
				setup=false
		2:#standing there menacingly
			if !setup:
				if tvec.length()>8.0: state=9
				else:
					setup=true
					vul=true
					air.start(randf_range(2.0,5.0))
					anim.play("ArmDrownStand")
					snd_voice.stream=voices[0]
					snd_voice.play()
			dir = tvec.normalized()
			looker(delta,4)
			
			#if it's in range she bites
			if tvec.length()<5.0:
				setup=false
				state=6
		3:#submerging
			if !setup:
				vul=false
				anim.play("ArmDrownDive",0.5)
				sfx_splash.restart()
				snd_splash.play()
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
				snd_hit.play()
				snd_voice.stream=voices[3]
				snd_voice.play()
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
				sfx_death.restart()
				snd_voice.stream=voices[2]
				snd_voice.play()
				anim.play("ArmDrownDeath",0.1)
			t+=delta
			if t>5:
				mesh.scale.y=7.5-t
			if t>7.5:
				queue_free()
		6:#SHARK BITE!
			if !setup:
				anim.play("ArmDrownBite")
				vul=true
				setup=true
				t=0.0
			looker(delta,8)
			t+=delta
			if t<0.5:
				dir = tvec.normalized()
			if t>1.25:
				setup=false
				state=3
		7:#intro
			if !setup:
				anim.play("ArmDrownCrouch")
				setup=true
				t=0.0
		8:#ambush!
			if !setup:
				t=0.0
				anim.play("ArmDrownAmbush",0.2)
				sfx_splash.restart()
				snd_splash.play()
				vul=true
				setup=true
			
			t+=delta
			if t<1.0: dir = tvec.normalized()
			looker(delta,8)
			
			if t>2:
				state=2
				air.start(randf_range(2.0,5.0))
				setup=false
				t=0.0
			pass
		9:#bubble spray
			if !setup:
				setup=true
				t=0.0
				anim.play("ArmDrownLaugh")
				vul=true
				attack=false
			
			dir = tvec.normalized()
			looker(delta,8)
			
			t+=delta
			if t>1.8 and !attack:
				attack=true
				bubbler.act()
				snd_voice.stream=voices[1]
				snd_voice.play()
			if t>3.8:
				bubbler.stop()
				state=3
				setup=false
				vul=false

func _physics_process(delta: float) -> void:
	
	if state==0: #crawling underwater
		var col= move_and_collide(delta*dir*speed)
		if col: dir=dir.bounce(col.get_normal())

func _on_seek_player_timeout() -> void:
	target=NewFunc.nearest_in_group("Player",transform.origin)
	if target:
		tarpos=target.global_position
		tvec=NewFunc.flat(tarpos-global_position)

func _on_air_timeout() -> void:
	match state:
		0:
			if emerge_ok:
				setup=false
				if tvec.length()<4.5:
					state=8
				else: state=1
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
		air.stop()
		vul=false
		health-=1
		setup=false
		bubbler.stop()
		sfx_hit.restart()
		if health>0: state=4
		else: state=5

func act():
	state=0
	setup=false
	_on_air_timeout()

func looker(delta : float, look_speed : float):
		ldir=NewFunc.flat(ldir.rotated(Vector3.UP,ldir.signed_angle_to(dir,Vector3.UP)*delta*look_speed)).normalized()
		look_at(global_position-ldir)
