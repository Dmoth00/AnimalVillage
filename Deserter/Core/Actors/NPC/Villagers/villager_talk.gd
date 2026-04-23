extends Area3D
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
	stored_dir=global_transform.basis.z
	dir=stored_dir
	
func act(player : CharacterBody3D) -> void:
	get_tree().get_first_node_in_group("TXT").act(texts,self)
	target_dir=(global_position-player.global_position).normalized()
	player.ltgt=NewFunc.flat(global_position-player.global_position).normalized()

func _process(delta: float) -> void:
	if !talking: target_dir=stored_dir
	if dir!=target_dir:
		dir=dir.rotated(Vector3.UP,dir.signed_angle_to(target_dir,Vector3.UP)*delta*10).normalized()
		#dir=dir.slerp(target_dir,delta*10).normalized()
		look_at(global_position-dir,Vector3.UP)
