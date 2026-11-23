extends AnimationPlayer
@export var event : String
@export var animation : StringName

func _ready() -> void:
	if event: play(animation)

func act():
	play(animation,1)
