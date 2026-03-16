extends LookAtModifier3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_eyes_area_body_entered(body: Node3D) -> void:
	target_node=body.get_path()
	pass # Replace with function body.

func _on_eyes_area_body_exited(_body: Node3D) -> void:
	target_node=""
	pass # Replace with function body.
