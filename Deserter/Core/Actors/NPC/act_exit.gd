extends Area3D
@export var newPosition : Vector3
@export var newMap : String
@export var sound : AudioStream

@onready var cam : Node3D
var p

func act(player : CharacterBody3D):
	p=player
	#stop the player
	p.anim.play("CharAnim_Stand",0.5,1.0)
	p.state=2
	p.can_move=false
	#make them invulnerable
	p.col.set_deferred("disabled",true)
	p.vul_timer.start(2.0)
	#fade out the camera
	cam=get_tree().get_first_node_in_group("Camera")
	cam.fade_out(0.25)
	get_node("t").start(0.75)



func _on_t() -> void:
	var g=get_tree().get_first_node_in_group("GM")
	var keep=get_tree().get_first_node_in_group("Keep")
	g.remove_child(keep)
	for i in g.get_children(): i.queue_free()
	g.add_child(keep)
	var new=load(newMap).instantiate()
	g.add_child(new)
	

	
	p.transform.origin=newPosition
	p.can_move=true
	cam.global_position=p.global_position
	cam.fade_in(0.5)
	
	
		#play the door's sound
	if sound:
		var snd=p.get_node("SFX")
		snd.stream = sound
		snd.play()
	
	
	
