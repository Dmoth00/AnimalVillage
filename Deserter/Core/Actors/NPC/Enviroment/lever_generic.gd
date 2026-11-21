extends Area3D
var p
@onready var anim = $anim
@onready var t = $t
@export var event : String
@export var sound : AudioStream

signal on_lever_pull

func _ready() -> void:
	var done : bool = gvars.event_list.has(event)
	if done:
		anim.play("down")
		remove_from_group("Act")

func act(player : CharacterBody3D):
	p=player
	#stop the player
	p.anim.play("CharAnim_Lever",0.1,1)
	p.state=2
	p.can_move=false
	p.ltgt=NewFunc.flat(global_position-player.global_position).normalized()
	p.col.set_deferred("disabled",true)
	p.vul_timer.start(2.0)
	p.can_move_timer.start(1.8)
	t.start(1.0)
	#can no longer act
	remove_from_group("Act")
	get_node("col").disabled=true
	#set flag
	gvars.event_list.append(event)

func _on_t() -> void:
		#lever sound and animation?
	var snd=p.get_node("SFX")
	snd.stream = sound
	snd.play()
	anim.play("pull_down")
	on_lever_pull.emit()
