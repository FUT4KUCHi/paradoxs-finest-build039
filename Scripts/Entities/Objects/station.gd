class_name Station extends Node3D

@onready var timer = $Timer
@onready var pan_cooking = $"Visuals/pan-stew2"
@onready var pan_empty = $Visuals/pan2
@onready var indicator = $Indicator

var has_item: bool
var stored_item_id: String = ""
var is_cooking: bool = false
var visual_empty: Node3D
var visual_cooking: Node3D


func _ready():
	add_to_group("SnappingPoints")
	add_to_group("Interactable")
	add_to_group("Station")
	$Indicator.visible = false
	_swap_visuals()

func _swap_visuals():
	print("Swapping Visuals.")
	
	if is_cooking:
		# clear_visual_instance()
		pan_cooking.visible = true
		$AnimationPlayer.play("Cooking")
		$AnimationPlayer.play("ProgressBar")
		$ProgressBar.visible = true
		
	elif has_item == false and is_cooking == false:
		# clear_visual_instance()
		pan_cooking.visible = false
		
	elif has_item and not is_cooking:
		$AnimationPlayer.stop() 
		
	else:
		pass

func add_item(item_id: String):
	is_cooking = true
	stored_item_id = item_id
	timer.start(5.0)
	_swap_visuals()

# TODO -> Think of a better name, if possible.
# This might look confusing, and it's done this way for a reason.
func on_interact() -> String:
	return stored_item_id

func remove_item():
	stored_item_id = ""
	has_item = false
	is_cooking = false
	_swap_visuals()
	for child in get_children():
		if child.is_in_group("Item"):
			child.queue_free()

func clear_visual_instance():
	for child in $Visuals.get_children():
		if child.is_in_group("temp_visual"):
			print(child)
			child.queue_free()

func _on_timer_timeout():
	$ProgressBar.visible = false
	var dish = Global.get_item_data(stored_item_id)
	if dish.can_be_processed:
		var dish_id = Global.get_ingredient_data(stored_item_id).processed_item_id
		stored_item_id = dish_id
		is_cooking = false
		has_item = true
	_swap_visuals()
