extends StaticBody3D

@onready var xplod=$xplod
@onready var xplod2=$xplod2
@onready var snd=$snd
@onready var col=$col
@onready var mesh=$PotMesh00


@onready var id : String


func _hurt(dmg : float):
	if dmg>0.0:
		xplod.emitting=true
		xplod2.emitting=true
		gvars.kill_list.append(id)
		print(str(id)+" has died.")
		mesh.queue_free()
		col.disabled=true
		snd.play()
		set_deferred("process_mode","PROCESS_MODE_DISABLED")
		pass
