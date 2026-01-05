extends CanvasLayer

@export var player : CharacterBody3D
@onready var state : int = -1
@onready var box = $Box
@onready var tbox = $Box/Text
@onready var t = 0.0

@onready var text_queue : Array[String]


func _ready() -> void:
	refresh()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match(state):
		0:
			t+=delta*4
			box.scale.x=t
			if t>=1.0:
				state=1
				t=0.0
				print("window opened successfully")
		1: 
			t+=delta*4
			if t>=0.1:
				t=0.0
				tbox.visible_characters+=1
				if tbox.visible_ratio==1.0: state=2
		3:
			t+=delta*4
			box.scale.x=1.0-t
			if t>=1.0:
				refresh()
				player.can_move=true
		

	pass

func act(display_text : Array[String]):
	if state==-1:
		text_queue=display_text.duplicate()
		if text_queue.size()>0: box.text=text_queue[0]
		text_queue.pop_front()
		state=0
		player.can_move=false

func refresh():
	box.scale.x=0.0
	tbox.visible_characters=0
	t=0.0
	state=-1
	

	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("gp_activate") and state==2:
		tbox.visible_characters=0
		
	if event.is_action("gp_run") and state==1: t+=0.1
	
