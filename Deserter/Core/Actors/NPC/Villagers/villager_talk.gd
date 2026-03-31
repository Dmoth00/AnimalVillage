extends StaticBody3D
@export var key=""
@onready var texts : Array
@export var turnToLook = true

var target_dir : Vector3
var dir : Vector3
var stored_dir : Vector3
var talking = false


func _ready() -> void:
	var txtfile=JSON.new
	var file=FileAccess.open("res://Data/dialog.json", FileAccess.READ)
	txtfile=JSON.parse_string(file.get_as_text())
	file.close()
	texts = txtfile[key]
	stored_dir=-global_transform.basis.z
	
func act(player : CharacterBody3D) -> void:
	get_tree().get_first_node_in_group("TXT").act(texts,self)
	dir=-global_transform.basis.z
	target_dir=(player.global_position-global_position+Vector3.UP*0.001).normalized()

func store_dir(): stored_dir=-global_transform.basis.z

func _process(delta: float) -> void:
	if !talking: target_dir=stored_dir
	
	if dir!=target_dir:
		dir=dir.slerp(target_dir,delta*10).normalized()
		look_at(global_position+dir,Vector3.UP)
