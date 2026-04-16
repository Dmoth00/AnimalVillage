extends Area3D
var p
@onready var anim = $anim
@onready var light = $light
@onready var t = $t
@export var sound : AudioStream

func _ready() -> void:
	lightswitch()
	pass

func act(player : CharacterBody3D):
	p=player
	#stop the player
	p.anim.play("CharAnim_Lever",0.1,1)
	p.state=2
	p.can_move=false
	p.ltgt=NewFunc.flat(global_position-player.global_position).normalized()
	p.col.set_deferred("disabled",true)
	p.vul_timer.start(2.0)
	p.can_move_timer.start(1.8)
	t.start(1.0)

		
func lightswitch():
	if gvars.night: light.position.x=-0.7
	else: light.position.x=0.7
	pass


func _on_t() -> void:
		#lever sound and animation?
	var snd=p.get_node("SFX")
	snd.stream = sound
	snd.play()
	anim.play("act")
	#switch the night
	gvars.night=!gvars.night
	lightswitch()
	
	pass # Replace with function body.
