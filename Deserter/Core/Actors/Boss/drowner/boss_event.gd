extends Node

@export var id : String

@onready var bgm=$BGM_Boss
@onready var cage=$cage


var t =0.0
var state = 0
var setup=false

func _ready() -> void:
	if gvars.event_list.has(id): queue_free()
	set_process(false)

func _process(delta: float) -> void:
	
	t+=delta/2
	
	if state==0:
		if !setup:
			bgm.play()
			setup=true
		cage.position.y=t*2-2
		bgm.volume_db=lerpf(-80.00,-6.0,t)
		if t>1.0:
			t=0.0
			set_process(false)
	else:
		cage.position.y=t*-2
		bgm.volume_db=lerpf(-80.00,-6.0,1-t)
		if t>1.0:
			t=0.0
			bgm.queue_free()
			cage.queue_free()
			gvars.event_list.append(id)
			set_process(false)
	pass

func BossDeath():
	state=1
	act()

func act(): set_process(true)
