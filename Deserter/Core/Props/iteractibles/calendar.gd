extends Area3D
#this is a dummy variable but else the system doesn't work, gomen
var talking = false
const weekdays=["Monday","Tuesday","Wendesday","Thursday","Friday","Saturday","Sunday"]
@onready var texts

func _ready() -> void:
	var day = get_day()
	texts =["A calendar hangs here.",day]
	pass


func act(player : CharacterBody3D) -> void:
	player.ltgt=NewFunc.flat(global_position-player.global_position).normalized()
	get_tree().get_first_node_in_group("TXT").act(texts)
	pass
	

func get_day():
	var raw_day = gvars.day
	var daynumber=(raw_day % 31)+19
	var weekday=raw_day % 7
	var rtxt = "Today is "+weekdays[weekday]+", "+str(daynumber)+"th of March."
	return rtxt
