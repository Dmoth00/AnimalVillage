extends Area3D
@export var texts : Array[String]


func act(player : CharacterBody3D) -> void:
	get_tree().get_first_node_in_group("TXT").act(texts)
	pass
