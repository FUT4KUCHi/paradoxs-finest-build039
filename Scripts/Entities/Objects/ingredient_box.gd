class_name IngredientBox extends Node3D

@export var ingredient: ItemResource

func _ready():
	add_to_group("Interactable")
	add_to_group("IngredientBox")

func on_interact():
	return ingredient.id

#func on_interact():
	#var item: ItemResource = Global.get_ingredient_data("rice-ball")
	#return item.id
