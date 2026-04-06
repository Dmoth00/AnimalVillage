extends Node
@export var functionName = ""
@export var arguments : Array

func _on_timeout() -> void:
	if arguments.is_empty(): call(functionName)
	else: call(functionName,arguments)
	pass # Replace with function body.
