extends Node3D

@export var action : StringName

@export var arguments : Array

func act():
	var mycall=Callable(self,action)
	mycall.callv(arguments)
