extends Area3D
@export var id : String

@onready var man= $mannequin02
@onready var xplod=$xplod


func _on_body_entered(_player: Node3D) -> void:
	gvars.event_list.append(id)
	xplod.act()
	xplod.reparent(get_parent(),true)
	call_deferred("queue_free")
	pass # Replace with function body.
