extends Node3D
@export var goods : String
@export var amount : int = 1

@onready var id = ""

func _process(delta: float) -> void:
	rotate_y(delta*PI)
	pass

func act():
	var cam=get_tree().get_first_node_in_group("Camera")
	cam.stream_play("uid://vpb56tcq1h85")
	var value = gvars.get(goods)
	value+=amount
	gvars.set(goods,value)
	call_deferred("queue_free")
