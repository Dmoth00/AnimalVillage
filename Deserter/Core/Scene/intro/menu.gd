extends CanvasLayer

@onready var next=load("res://Core/Scene/outside/start_room.tscn")
@onready var state=0
@onready var t=0.0
@onready var menu=$menu
@onready var fader=$fader
@onready var bgm=$bgm
@onready var point=$menu/point
@onready var p_pos : int = 0

func _ready() -> void:
	menu.scale.y=0.0
	fader.modulate.a=0.0

func _process(delta: float) -> void:
	t+=delta
	
	match state:
		1: menu.scale.y=minf(1.0,menu.scale.y+delta*2)
		2: 
			fader.modulate.a=min(1,fader.modulate.a+2*delta)
			bgm.volume_db-=delta*80
			if t>1.0: _next(next)
			
		
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("gp_activate"): _act()
	if event.is_action_pressed("db_restart"): gvars.reset()
	if event.is_action_pressed("gp_up") and state==1: move_p(-1)
	if event.is_action_pressed("gp_down") and state==1: move_p(1)

	
func _act():
	if t>0.5:
		t=0.0
		if state==1:
			match p_pos:
				(0):state=2
				(3):get_tree().quit()
		
		if state==0: state=1
	
func _next(n):
	
	var gm=get_tree().get_first_node_in_group("GM")
	var tit=gm.get_child(0)
	#ensure child survives
	var scn=n.instantiate()
	gm.add_child(scn)
	#and then self destruct
	gm.remove_child(tit)
	tit.call_deferred("queue_free")
	
func move_p(i : int):
	p_pos=(p_pos+i)%4
	point.position.y=p_pos*40-120
	pass
