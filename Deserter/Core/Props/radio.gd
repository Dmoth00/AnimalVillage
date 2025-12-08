extends StaticBody3D
@onready var light=$light
@onready var smoke=$smoke
@onready var snd=$shock
@onready var col=$col
var t = 0.0


func _process(delta: float) -> void:
	if light!=null:
		t+=delta
		if t>0.5: t=0
		light.scale=Vector3.ONE*t
	pass

func _hurt(dmg : float):
	if dmg>0.0:
		light.queue_free()
		smoke.emitting=true
		col.disabled=true
		snd.play()
		set_deferred("process_mode","PROCESS_MODE_DISABLED")
		pass
