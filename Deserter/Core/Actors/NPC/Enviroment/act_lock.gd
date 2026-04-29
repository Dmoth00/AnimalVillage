extends Area3D
@export var newPosition : Vector3
@export var newMap : String
@export var openSound : AudioStream
@export var lockedSound : AudioStream
@export var unlockSound : AudioStream
@export var playBefore : bool = false
@export var timeToWarp = 0.75

@export var key : String = "debugKey"

@onready var cam : Node3D
var p

@export var closedDialog : Array [String] = ["The door is locked."]

func act(player : CharacterBody3D):
	get_tree().get_first_node_in_group("TXT").act(closedDialog)
	pass


func _on_t() -> void:
	if newMap!="":
		var g=get_tree().get_first_node_in_group("GM")
		var keep=get_tree().get_first_node_in_group("Keep")
		g.remove_child(keep)
		for i in g.get_children(): i.queue_free()
		g.add_child(keep)
		var new=load(newMap).instantiate()
		g.add_child(new)
		get_tree().get_first_node_in_group("Camera").kill_list(new)
	p.transform.origin=newPosition
	p.can_move=true
	cam.global_position=p.global_position
	cam.fade_in(0.5)
	
	#play the door's sound
	if playBefore==false: doorSound(openSound)

func doorSound(sound : AudioStream):
	if sound:
		var snd=p.get_node("SFX")
		snd.stream = sound
		snd.play()

func open(player : CharacterBody3D):
	p=player
	#stop the player
	p.anim.play("CharAnim_Lever",0.5,3)
	p.state=2
	p.can_move=false
	#make them invulnerable
	p.col.set_deferred("disabled",true)
	p.vul_timer.start(2.0)
	#fade out the camera
	cam=get_tree().get_first_node_in_group("Camera")
	cam.fade_out(0.25)
	get_node("t").start(timeToWarp)
	#play noise
	if playBefore: doorSound(openSound)
	pass
