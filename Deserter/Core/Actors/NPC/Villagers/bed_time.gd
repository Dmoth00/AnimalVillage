extends Node3D

@onready var state : int
@export var dayChanger : Node

var t : float
var stopper : int
var player : CharacterBody3D
var cam : Node3D
var pos_a : Vector3
var pos_b : Vector3
var rot_a : Vector3
var mid_point : Vector3
var new_point : Vector3

var fl_on : bool 

#set up variables and deactivate
func _ready() -> void:
	refresh()
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		#initial set up and also grasping the player
		0:
			player=get_tree().get_first_node_in_group("Player")
			cam=get_tree().get_first_node_in_group("Camera")
			player.inputOff=true
			player.can_move=false
			player.state=2
			player.set_physics_process(false)
			
			if player.fl:
				fl_on=true
				player.flashlight()
			player.anim.play("CharAnim_Bed")
			player.ltgt=Vector3.RIGHT
			
			pos_a=player.position
			pos_b=mid_point
			state=1
			t=0.0
			stopper=0
		#the next two are animation steps to move the player corectly
		1:
			t=min(t+delta*2,1.0)
			player.position=pos_a.lerp(pos_b,t)
			if t==1.0:
				if stopper==0:
					t=0.0
					player.ltgt=Vector3.BACK
					pos_a=mid_point
					pos_b=position
					stopper=1
				else:
					t=0.0
					stopper=4
					cam.fade_out(2)
					state=2
		#now we wait for lights out and then mode time forward
		2:
			t+=delta
			if t>stopper:
				match stopper:
					4:
						stopper=6
						gvars.day_forward()
						gvars.kill_list.clear()
						dayChanger.act()
						cam.fade_in(2)
					6:
						player.anim.play("CharAnim_BedLeave")
						stopper=8
					8:
						state=3
						stopper=0
						t=0.0
						player.ltgt=Vector3.RIGHT
						pos_b=position
						pos_a=mid_point
		#now we animate the player leaving the bed
		3:
			t=min(t+delta*2,1.0)
			player.position=pos_b.lerp(pos_a,t)
			if t==1.0:
				match stopper:
					0:
						pos_b=mid_point
						pos_a=new_point
						stopper=1
						t=0.0
					1:
						state=4
						t=0.0
		4:
			t+=delta
			if t>0.5:
				player.inputOff=false
				player.set_physics_process(true)
				player.can_move=true
				player.ltgt=Vector3.BACK
				if fl_on: player.flashlight()
				refresh()
				set_process(false)

func refresh():
	t=0.0
	stopper=0
	state=0
	fl_on = false
	mid_point=get_node("midpoint").position
	new_point=get_node("newpoint").position

#once called once it activates
func act():
	refresh()
	set_process(true)
	pass
