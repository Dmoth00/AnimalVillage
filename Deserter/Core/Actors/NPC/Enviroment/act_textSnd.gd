extends Area3D
@export var texts : Array[String] = ["Nothing Here.", "...And Yet..."]
@export var sound : AudioStream
#this is a dummy variable but else the system doesn't work, gomen
var talking = false

@onready var snd = $snd

func _ready() -> void:
	if sound: snd.stream=sound
	pass

func act(player : CharacterBody3D) -> void:
	if sound: snd.play()
	player.ltgt=NewFunc.flat(global_position-player.global_position).normalized()
	get_tree().get_first_node_in_group("TXT").act(texts)
	pass
