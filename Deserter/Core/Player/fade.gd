extends ColorRect


@onready var inc : float

func _ready() -> void:
	fade_in(0.5)

func _process(delta: float) -> void:
	color.a=clampf(color.a+inc*delta,0,1)
	if color.a==0 or color.a==1: set_process(false)

func fade_in(t : float):
	color.a=1.0
	inc=t*-1
	set_process(true)

func fade_out(t : float):
	color.a=0.0
	inc=t
	set_process(true)
