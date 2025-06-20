extends Control

var available_items: Array[ItemResource] = []
@onready var preview = $MarginContainer/VBoxContainer/MidMargin/HBoxContainer/VBoxContainer/MarginContainer2/HBoxContainer/ItemPreview
@onready var shop_purchase_button = $MarginContainer/VBoxContainer/BottomMargin/MarginContainer/HBoxContainer/ShopPurchaseButton
@onready var label = $MarginContainer/VBoxContainer/TopMargin/Label

var index: int = 0
var selected_item: ItemResource

func _ready():
	Global._register_ingredients()
	available_items = parse_resource_dict_to_array(Global.ingredient_registry)
	show_item(index)

func parse_resource_dict_to_array(dict: Dictionary) -> Array[ItemResource]:
	var result: Array[ItemResource] = []
	for key in dict.keys():
		var resource = dict[key]
		if resource is ItemResource:
			result.append(resource)
	return result

func show_item(i: int) -> void:
	index = (i + available_items.size()) % available_items.size()
	selected_item = available_items[index]
	preview.texture = selected_item.visual
	label.text = selected_item.id
	shop_purchase_button.text = str(selected_item.cost)

func _on_left_button_pressed():
	show_item(index - 1)

func _on_right_button_pressed():
	show_item(index + 1)
