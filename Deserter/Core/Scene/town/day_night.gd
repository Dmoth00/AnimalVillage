extends Node3D

func _ready() -> void:
	var night=$Night
	var day=$Day
	if gvars.night: day.queue_free()
	else: night.queue_free()
