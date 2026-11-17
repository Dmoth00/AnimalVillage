extends StaticBody3D
@export var enemyOwner : Node

func _hurt(dmg : float):
	print ("Hit the target!")
	enemyOwner.hurt(dmg)
