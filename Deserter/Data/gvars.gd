extends Node

# Declare global variables here.

#player vars
var blood : float
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

#constants
const wigl=Vector3(0.01,0,0.01)

#this will always happen at game start
func _ready():
	var_init()

#this initializes the game
func var_init():
	
	blood = 5.0
	bloodBag = 5.0
	gun = chamber
	bullets = 18
	hatred = 0.0
	pcontrol = true
	
	#text_script = load_data("res://data/script.json")
	kill_list = []
	event_list = []
	items=[]
	pass

func reset():
	var_init()
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
