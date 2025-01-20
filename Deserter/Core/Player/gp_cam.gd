extends Node3D

@onready var player
@onready var target = global_position



func _ready() -> void:
	get_player()
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if player!=null:
		target=player.global_position
	global_position=global_position.lerp(target,delta*12)

func get_player(): player = get_tree().get_nodes_in_group("Player")[0]
