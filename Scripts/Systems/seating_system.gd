class_name SeatingSystem 
extends Node

var chairs: Array = []

func _ready():
	chairs = %ChairsRoot.get_children()

func request_available_chair() -> Node3D:
	for chair in chairs:
		if chair.has_method("is_taken") and not chair.call("is_taken"):
			chair.call("set_taken", true)
			return chair
	return null

func release_chair(chair: Node3D):
	if chair and chair.has_method("set_taken"):
		chair.call("set_taken", false)
