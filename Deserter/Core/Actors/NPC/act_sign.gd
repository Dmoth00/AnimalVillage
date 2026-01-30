extends Area3D
@export var texts=""

func act(_player : CharacterBody3D) -> void:
	get_tree().get_first_node_in_group("TXT").act(texts)
	pass
