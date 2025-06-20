extends Node

func _ready() -> void:
	add_to_group("Interactable")
	add_to_group("Shop")

func _on_area_3d_body_entered(body):
	if body.has_method("_handle_interaction"):
		print("Player has entered the shop.")
		SignalBus.player_around_shop.emit()

func _on_area_3d_body_exited(body):
	if body.has_method("_handle_interaction"):
		print("Player has exited the shop.")
		SignalBus.player_not_around_shop.emit()
