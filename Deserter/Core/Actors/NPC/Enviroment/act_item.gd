extends Area3D
@export var texts1 : Array[String] = ["A key is here.", "The key has been obtained."]
@export var texts2 : Array[String] = ["There is nothing else for you to take."]
@export var itemID : String
#this is a dummy variable but else the system doesn't work, gomen
var talking = false
@onready var id : String

func _ready() -> void:
	id=str(name)+itemID

func act(player : CharacterBody3D) -> void:
	
	player.ltgt=NewFunc.flat(global_position-player.global_position).normalized()
	
	if !gvars.event_list.has(id):
		gvars.event_list.append(id)
		gvars.items.append(itemID)
		get_tree().get_first_node_in_group("TXT").act(texts1)
	else:
		get_tree().get_first_node_in_group("TXT").act(texts2)
