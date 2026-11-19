extends CharacterBody3D

var damage=0.5
var knockdown = false

var target
var tarpos : Vector3
var tvec : Vector3
var dir =  transform.basis.z



@onready var pop=$popSfx

func _ready() -> void:
	get_node("death").start(randf_range(5.0,10.0))

func _process(_delta: float) -> void:
	velocity=lerp(velocity, dir*2.0, 0.05)
	move_and_slide()

func act():
	pop.reparent(get_parent(),true)
	pop.act()
	call_deferred("queue_free")

func _hurt(_dmg : float):
	act()

func _on_seek_player_timeout() -> void:
	target=NewFunc.nearest_in_group("Player",transform.origin)
	if target:
		tarpos=target.global_position
		tvec=NewFunc.flat(tarpos-global_position)
		dir=tvec.normalized()
