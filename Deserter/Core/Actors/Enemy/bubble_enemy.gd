extends CharacterBody3D

var damage=0.5
var knockdown = false

var target
var tarpos : Vector3
var tvec : Vector3
var dir =  transform.basis.z

@onready var pop=$popSfx
@onready var anim=$anim

@onready var id : String

func _ready() -> void:
	anim.play("bubbleStand")
	anim.seek(randf_range(0.0,3.8))


func act():
	pop.reparent(get_parent(),true)
	pop.act()
	
	gvars.kill_list.append(id)
	print(str(id)+" has died.")
	call_deferred("queue_free")

func _hurt(_dmg : float):
	act()
