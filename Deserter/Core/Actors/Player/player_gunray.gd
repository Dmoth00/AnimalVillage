extends RayCast3D
@onready var guy=$guy

func _timer() -> void:
	if is_colliding():
		guy.visible=true
		guy.global_position=get_collision_point()
	else: guy.visible=false
	pass # Replace with function body.
