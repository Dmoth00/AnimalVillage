extends Node3D
@export var texts : Array[String] = ["Nothing Here.", "...And Yet..."]
@export var turnToLook = true

@onready var snd = $snd

@export var react : Node

var target_dir : Vector3
var dir : Vector3
var stored_dir : Vector3
var talking = false
var txt : Node


func _ready() -> void:
	stored_dir=global_transform.basis.z
	dir=stored_dir
	txt=get_tree().get_first_node_in_group("TXT")

	
func act(player : CharacterBody3D) -> void:
	txt.act(texts,self,react)
	if react!=null:
		pass
	if turnToLook: target_dir=(global_position-player.global_position).normalized()
	player.ltgt=NewFunc.flat(global_position-player.global_position).normalized()
	if snd!=null: snd.play()

func _process(delta: float) -> void:
	if !talking: target_dir=stored_dir
	if dir!=target_dir:
		dir=dir.rotated(Vector3.UP,dir.signed_angle_to(target_dir,Vector3.UP)*delta*10).normalized()
		#dir=dir.slerp(target_dir,delta*10).normalized()
		look_at(global_position-dir,Vector3.UP)
