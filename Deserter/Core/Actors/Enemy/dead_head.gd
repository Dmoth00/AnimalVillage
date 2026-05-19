extends CharacterBody3D
@onready var health : int = 6
@export var damage=0.5
@onready var anim=$anim

@onready var id : String
@export var dnr : bool = false

var knockdown = true

func _hurt(_dmg : float):
	health -= 1
	gvars.hatred+=randf_range(0.1,0.3)
	gvars.bloodBag+=(1+gvars.hatred)*0.1
	var bld=get_node("bloodSFX").duplicate()
	get_parent().add_child(bld)
	bld.global_position=global_position
	bld.act()
	match health:
		5: anim.play("Dhead_1")
		4: anim.play("Dhead_2")
		3: anim.play("Dhead_3")
		2: anim.play("Dhead_4")
		1: anim.play("Dhead_5")
		0:_death()

func _death():
	get_tree().get_first_node_in_group("Player").get_node("bloodGet").restart()
	if dnr: gvars.event_list.append(id)
	else: gvars.kill_list.append(id)
	print(str(id)+" has died.")
	call_deferred("queue_free")
