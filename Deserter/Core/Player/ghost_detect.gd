extends Area3D


func _on_body_entered(body: Node3D) -> void:
	_seen(body,true)

	
func _on_body_exited(body: Node3D) -> void:
	_seen(body,false)


func _seen(obj : Node3D,vis : bool):
	var n=NewFunc.get_all_children(obj)
	for i in n:
		if i.is_in_group("Fade"):
			i.seen=vis
	pass
