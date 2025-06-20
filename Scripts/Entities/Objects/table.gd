class_name Table extends Node3D

@onready var snap_point = $ItemSpace/SnapPoint
@onready var indicator = $Indicator
@onready var animation_player = $AnimationPlayer

var level: Node = null
var has_item: bool = false

var stored_item_id: String = ""

var assigned_customer: CharacterBody3D = null
var taken: bool = false

func _ready():
	add_to_group("SnappingPoints")
	add_to_group("Interactable")
	add_to_group("Table")

func add_item(item_id: String):
	has_item = true
	stored_item_id = item_id
	instantiate_item_scene()

# TODO -> Think of a better name, if possible.
# This might look confusing, and it's done this way for a reason.
func on_interact() -> String:
	return stored_item_id

func remove_item():
	stored_item_id = ""
	has_item = false
	for child in get_children():
		if child.is_in_group("Item"):
			child.queue_free()

func instantiate_item_scene() -> void:
	var scene = Global.get_item_data(stored_item_id).scene
	var instance = scene.instantiate()
	instance.add_to_group("Item")
	add_child(instance)
	instance.global_transform.origin = snap_point.global_transform.origin


func is_taken() -> bool:
	return taken

func set_taken(value: bool):
	taken = value

func assign_customer_to_table(customer: CharacterBody3D) -> void:
	taken = true
	assigned_customer = customer
