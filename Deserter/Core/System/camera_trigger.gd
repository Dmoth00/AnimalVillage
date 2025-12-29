extends Area3D

@export var cameraAngle = -60.0
@export var cameraZoom = 6.0
@export var cameraOffset = Vector2.ZERO
@onready var cam

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam=get_tree().get_first_node_in_group("Camera")
	pass # Replace with function body.

func _on_body_entered(_body: Node3D) -> void:
	cam.camdist = cameraZoom
	cam.camangl = cameraAngle
	cam.camoff = cameraOffset
	
func _on_body_exited(_body: Node3D) -> void:
	cam.reset_cam()
