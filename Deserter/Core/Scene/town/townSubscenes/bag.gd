extends StaticBody3D
@onready var id : String


func _hurt(dmg : float):
	if dmg>0.0:
		get_node("anim").pause()
		get_node("bloodSFX/snd").play()
		get_node("bloodSFX").emitting=true
		gvars.hatred+=0.01
		gvars.bloodBag+=1.0+gvars.hatred
		gvars.kill_list.append(id)
		print(str(id)+" has died.")
		get_node("col").disabled=true
		get_tree().get_first_node_in_group("Player").get_node("bloodGet").restart()
		pass
