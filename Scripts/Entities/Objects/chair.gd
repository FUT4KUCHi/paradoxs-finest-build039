extends StaticBody3D

var taken: bool = false

func is_taken() -> bool:
	return taken

func set_taken(value: bool):
	taken = value
	
#	if taken == true:
#		print("This seat is currently taken.")
#	elif taken == false:
#		print("This seat is vacant now!")

func _on_area_3d_body_entered(body):
	if body.is_in_group("Customer"):
		body.set_state(body.State.SITTING)
