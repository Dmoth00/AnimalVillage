extends Node
@onready var night=$Night
@onready var day=$Day



func _ready() -> void:
	act()
	
func act():
	if gvars.night: 
		day.hide()
		day.position.y=100
		night.show()
		night.position.y=0
	else:	
		day.show()
		day.position.y=0
		night.hide()
		night.position.y=100
