extends Area3D
var p
@onready var anim = $anim
@onready var light = $light
@export var sound : AudioStream

func _ready() -> void:
	lightswitch()
	pass

func act(player : CharacterBody3D):
	p=player
	#stop the player
	p.anim.play("CharAnim_Stand",0.5,1.0)
	p.state=2
	p.can_move=false
	p.col.set_deferred("disabled",true)
	p.vul_timer.start(1.0)
	p.can_move_timer.start(1.0)
	#lever sound and animation?
	var snd=p.get_node("SFX")
	snd.stream = sound
	snd.play()
	anim.play("act")
	#switch the night
	gvars.night=!gvars.night
	lightswitch()
		
func lightswitch():
	if gvars.night: light.position.x=-0.7
	else: light.position.x=0.7
	pass
