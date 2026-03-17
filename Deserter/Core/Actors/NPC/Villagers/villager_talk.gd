extends StaticBody3D
@export var key=""
@onready var texts : Array

func _ready() -> void:
	var txtfile=JSON.new
	var file=FileAccess.open("res://Data/dialog.json", FileAccess.READ)
	txtfile=JSON.parse_string(file.get_as_text())
	file.close()
	texts = txtfile[key]
	
	
func act(_player : CharacterBody3D) -> void:
	get_tree().get_first_node_in_group("TXT").act(texts)
	pass
