extends Area3D
@export var id : String

@onready var man= $mannequin02
@onready var xplod=$xplod

@onready var corpse=$mannequinCorpse

func _on_body_entered(_player: Node3D) -> void:
	gvars.event_list.append(id)
	corpse.act()
	corpse.reparent(get_parent(),true)
	xplod.act()
	xplod.reparent(get_parent(),true)
	call_deferred("queue_free")
	pass # Replace with function body.
