extends StaticBody3D
@onready var light=$light
@onready var smoke=$smoke
@onready var xplod=$xplod
@onready var snd=$spark
@onready var col=$col
@onready var radio=$light/radio
@export var stream : AudioStreamMP3
var t = 0.0
@onready var id : String

func _ready() -> void:
	radio.stream=stream
	if stream!=null: radio.play()

func _process(delta: float) -> void:
	if light!=null:
		t+=delta
		if t>0.5: t=0
		light.scale=Vector3.ONE*t

func _hurt(dmg : float):
	if dmg>0.0:
		get_node("spark").play()
		xplod.emitting=true
		gvars.kill_list.append(id)
		print(str(id)+" has died.")
		light.queue_free()
		smoke.emitting=true
		col.disabled=true
		snd.play()
		set_deferred("process_mode","PROCESS_MODE_DISABLED")
		pass
