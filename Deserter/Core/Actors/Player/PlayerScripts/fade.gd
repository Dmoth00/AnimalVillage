extends ColorRect


@onready var inc : float

func _process(delta: float) -> void:
	color.a=clampf(color.a+delta/inc,0,1)
	if color.a==0 or color.a==1: set_process(false)
