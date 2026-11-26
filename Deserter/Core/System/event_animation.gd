extends AnimationPlayer
@export var event : String
@export var animation : StringName

func _ready() -> void:
	if gvars.event_list.has(event):
		call_deferred("play",animation,-1)

func act():
	play(animation,1)
