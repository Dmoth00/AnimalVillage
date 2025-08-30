extends OmniLight3D

var light = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	light_energy=lerpf(light_energy,light,20*delta)
	pass

func act (on : bool):
	if on: light=0.2
	else: light=0.0

func flash():
	light_energy=5.0
