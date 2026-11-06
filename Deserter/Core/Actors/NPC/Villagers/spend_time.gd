extends CanvasLayer

@export var question : String

@export var choice01 : String
@export var choice01Call : Node

@export var choice02 : String
@export var choice02Call : Node

@export var reverseDefault = false

@onready var state : int

@onready var q = $Question
@onready var qtext = $Question/Text

@onready var c1 = $Choice01
@onready var c1text = $Choice01/Text

@onready var c2 = $Choice02
@onready var c2text = $Choice02/Text

@onready var snd=$snd



var select : bool
var t : float
var player : CharacterBody3D

func _ready() -> void:
	refresh()
	print("I die!")
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		#initialization state
		-1:
			print("I live!")
			#freeze player
			player=get_tree().get_first_node_in_group("Player")
			player.inputOff=true
			player.can_move=false
			#write the strings
			q.get_node("Text").text=question
			c1text.text=choice01
			c2text.text=choice02
			state=0
		#the question box appears
		0:
			t=min(t+delta*4,1.0)
			q.scale.x=t
			if t==1.0:
				state=1
				t=0.0
		#the question is typed out
		1:
			t+=delta*4
			if t>0.1 or Input.is_action_pressed("gp_run"):
				t=max(t-0.1,0.0)
				qtext.visible_characters+=1
				if qtext.visible_ratio==1.0:
					t=0.0
					state=2
		#the choice boxes appear
		2:
			t=min(t+delta*4,1.0)
			c1.scale.x=t
			c2.scale.x=t
			if t==1.0:
				state=3
				t=0.0
				c1text.visible_ratio=1.0
				c2text.visible_ratio=1.0
				c1.modulate=Color.YELLOW
		#Action! the intro is done and now it's active.
		3:
			if Input.is_action_just_pressed("gp_left") or Input.is_action_just_pressed("gp_right"):
				snd.play()
				select=!select
				if select:
					c1.modulate=Color.YELLOW
					c2.modulate=Color.WHITE
				else:
					c2.modulate=Color.YELLOW
					c1.modulate=Color.WHITE
			var press = false
			if Input.is_action_just_pressed("gp_activate"):
				press=true
			if Input.is_action_just_pressed("gp_run"):
				press=true
				select=reverseDefault
			if press:
				snd.play()
				state=4
				qtext.visible_characters=0
				c1text.visible_characters=0
				c2text.visible_characters=0
		#closes the windows the selection is now decided
		4:
			t=min(t+delta*4,1.0)
			q.scale.x=1.0-t
			c1.scale.x=1.0-t
			c2.scale.x=1.0-t
			if t==1.0:
				t=0.0
				state=5
		#activate the object linked to the selection
		5:
			var c : Node
			if select: c=choice01Call
			else: c=choice02Call
			
			if c!=null: c.act()
			else:
				player.inputOff=false
				player.can_move=true
			
			refresh()
			set_process(false)

func act():
	refresh()
	set_process(true)

func refresh():
	state=-1
	c1.scale.x=0
	c2.scale.x=0
	q.scale.x=0
	qtext.visible_characters=0
	c1text.visible_characters=0
	c2text.visible_characters=0
	t=0.0
	select=true
	
