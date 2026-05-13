extends Area3D

@export var opensound : AudioStream
@export var lockedSound : AudioStream
var closedDialog : Array [String] = ["It doesn't open from this side."]
var closed=true
var over=false

var id : String

@onready var col=$doorcol
@onready var anim=$anim
@onready var col2=$col2

func act(player : CharacterBody3D):
	var p=player
	if closed:
		anim.play("anim_rattle")
		doorSound(lockedSound,p)
		get_tree().get_first_node_in_group("TXT").act(closedDialog)
	else:
		#don't repeat
		if over: return
		over=true
		
		#all this is just bells and whistles
		anim.play("anim_door")
		doorSound(opensound,p)
		
		#the door opens
		#the event trigger is saved
		gvars.event_list.append(id)
		#the collision is destroyed
		col.queue_free()
		#the colider's shape is disabled....
		col2.set_deferred("disabled",true)


func _on_opener_body_entered(_body: Node3D): closed=false

func _on_opener_body_exited(_body: Node3D): closed=true # Replace with function body.

func doorSound(sound : AudioStream, player : CharacterBody3D):
	if sound:
		var snd=player.get_node("SFX")
		snd.stream = sound
		snd.play()
