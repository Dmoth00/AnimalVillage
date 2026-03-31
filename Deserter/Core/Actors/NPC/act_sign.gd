extends Area3D
@export var texts : Array[String] = ["Nothing Here.", "...And Yet..."]
#this is a dummy variable but else the system doesn't work, gomen
var talking = false

func act(_player : CharacterBody3D) -> void:
	get_tree().get_first_node_in_group("TXT").act(texts)
	pass
