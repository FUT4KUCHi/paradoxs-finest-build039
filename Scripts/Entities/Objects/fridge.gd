class_name Fridge extends Node3D

func _ready():
	add_to_group("Interactable")
	add_to_group("Fridge")


func on_interact():
	#var ingredient_keys = Global.ingredient_registry.keys()
	#var item: ItemResource = Global.ingredient_registry[ingredient_keys[randi() % ingredient_keys.size()]]
	#return item.id
	
	pass

#func on_interact():
	#var item: ItemResource = Global.get_ingredient_data("egg")
	#return item.id

func _on_area_3d_body_entered(body):
	if body.has_method("_handle_interaction"):
		print("Player is nearby the Fridge")
		SignalBus.player_around_fridge.emit()

func _on_area_3d_body_exited(body):
	if body.has_method("_handle_interaction"):
		print("Player has left the Fridge area")
		SignalBus.player_not_around_fridge.emit()
