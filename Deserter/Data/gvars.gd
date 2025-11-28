extends Node

# Declare global variables here.

#player vars
var blood : float
var bloodMax : float
var bloodBag : float
const chamber : int = 6
var gun : int = chamber
var bullets : int
var hatred : float
var pcontrol : bool

#data vars
var text_script : Dictionary
var kill_list : Array
var event_list : Array
var items : Array

var night : bool
var day :int

#constants
const wigl=Vector3(0.01,0,0.01)
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#debug
var debug_mode = false

#this will always happen at game start
func _ready():
	var_init()

#this initializes the game
func var_init():
	
	blood = 5.0
	bloodMax = 6.0
	bloodBag = 5.0
	gun = chamber
	bullets = 18
	hatred = 0.0
	pcontrol = true
	
	#text_script = load_data("res://data/script.json")
	kill_list = []
	event_list = []
	items=[]
	
	night=true
	day=0
	
	debug_mode=false
	pass

func reset():
	var_init()
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


#call on instancing new maps
func assign_id(obj : Node):
	var obj_list : Array = get_tree().get_nodes_in_group("Id")
	for i in len(obj_list):
		var gen_id = obj.name+str(i)
		obj_list[i].id=gen_id
		check_id(obj_list[i],gen_id)

#check if the object should be dead
func check_id(obj : Node,id : String):
	if kill_list.has(id) or event_list.has(id):
		print(id)
		obj.queue_free()
