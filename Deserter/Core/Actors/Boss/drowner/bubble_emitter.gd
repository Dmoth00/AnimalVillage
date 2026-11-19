extends GPUParticles3D

var bubble=load("uid://deeln333quy4d")
var t = 0.0
var i : int = 0

func _ready() -> void:
	stop()

func _process(delta: float) -> void:
	t+=delta
	if t>0.25:
		t=0.0
		var bub=load("uid://deeln333quy4d").instantiate()
		get_tree().current_scene.add_child(bub)
		bub.position=global_position
		bub.velocity=global_basis.z*8
		i+=1
	if i==4:
		stop()

func act():
	emitting=true
	set_process(true)

func stop():
		i=0
		t=0.0
		emitting=false
		set_process(false)
	
