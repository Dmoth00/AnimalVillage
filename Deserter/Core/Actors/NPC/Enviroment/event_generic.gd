extends Node
@export var enter_list : Array[Node]
@export var exit_list : Array[Node]
@export var event : String

@export var is_item : bool
@export var on_load = true

func _ready() -> void: if on_load: act()

func act():
	var do : bool
	if is_item: do=gvars.items.has(event)
	else: do=gvars.event_list.has(event)
	
	if do:
		for a in exit_list: 
			a.queue_free()
	else:
		for a in enter_list:
			a.queue_free()
