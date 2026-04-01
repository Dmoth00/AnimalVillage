extends RayCast3D

@onready var sfx=$ripples
@onready var player=get_parent()
var speed = 0.0

func _on_check() -> void:
	player.in_water=false
	sfx.emitting=false
	if is_colliding():
		var other = get_collider()
		if other.is_in_group("Water"):
			player.in_water=true
			speed=player.velocity.length()
			sfx.global_position=player.global_position
			sfx.global_position.y=get_collision_point().y+0.001
			if speed>1.0:
				sfx.emitting=true


	pass # Replace with function body.
