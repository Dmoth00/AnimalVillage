extends Area3D
@export var id : String
@export var actors : Array[Node]

func _on_body_entered(_player: Node3D) -> void:
	if actors.is_empty(): return
	gvars.event_list.append(id)
	var i : int = 0
	while i < actors.size():
		actors[i].act()
		if self==actors[i].get_parent(): actors[i].reparent(get_parent(),true)
		i+=1
	call_deferred("queue_free")
