extends Node

@export var restaurent: PackedScene
@export var outskirts: PackedScene
@export var store: PackedScene
@export var start: PackedScene

# Scene Handling
@onready var world = $SubViewportContainer/SubViewport
var current_scene: Node
var current_level: String

# Diagnostics
@onready var time_label = $UserInterface/DebugPanel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/TimeLabel
@onready var velocity_label = $UserInterface/DebugPanel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/VelocityLabel
@onready var frames_label = $UserInterface/DebugPanel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/FramesLabel
@onready var scene_label = $UserInterface/DebugPanel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/SceneLabel
@onready var item_label = $UserInterface/DebugPanel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/ItemLabel
@onready var cash_label = $UserInterface/DebugPanel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CashLabel
@onready var shop_status_label = $UserInterface/DebugPanel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/ShopStatusLabel

# Interfaces
const UNKNOWN_ICON: Texture2D = preload("res://Assets/UI/UI_PNG/Extra/Default/button_square_line.png")
@onready var debug_panel = $UserInterface/DebugPanel
@onready var inventory_interface = $UserInterface/InventoryInterface
@onready var kitchen_storage_interface = $UserInterface/KitchenStorageInterface
@onready var shop_interface = $UserInterface/ShopInterface
@onready var label_cash = $UserInterface/ShopInterface/BottomRightMargin/LabelCash

var player: CharacterBody3D = null
var player_around_shop: bool = false
var player_around_fridge: bool = false
var player_cash: int = 0

# @onready var dialogic = DialogicUtil.get_dialogic_plugin()

func _ready() -> void:
	# _on_the_restaurent_pressed()
	_start()
	
	Global.player_cash = 300
	print(current_scene.name)
	print(player)
	# world.add_child(current_scene)
	print(Global.player)

	TimeManager.connect("time_changed", self._on_time_changed)
	TimeManager.connect("event_0am", self._on_event_0am)
	TimeManager.connect("event_1am", self._on_event_1am)
	TimeManager.connect("event_2am", self._on_event_2am)
	TimeManager.connect("event_3am", self._on_event_3am)
	TimeManager.connect("event_4am", self._on_event_4am)
	TimeManager.connect("event_5am", self._on_event_5am)
	TimeManager.connect("event_6am", self._on_event_6am)
	TimeManager.connect("event_7am", self._on_event_7am)
	TimeManager.connect("event_8am", self._on_event_8am)
	TimeManager.connect("event_9am", self._on_event_9am)
	TimeManager.connect("event_10am", self._on_event_10am)
	TimeManager.connect("event_11am", self._on_event_11am)
	TimeManager.connect("event_12pm", self._on_event_12pm)
	TimeManager.connect("event_13pm", self._on_event_1pm)
	TimeManager.connect("event_14pm", self._on_event_2pm)
	TimeManager.connect("event_15pm", self._on_event_3pm)
	TimeManager.connect("event_16pm", self._on_event_4pm)
	TimeManager.connect("event_17pm", self._on_event_5pm)
	TimeManager.connect("event_18pm", self._on_event_6pm)
	TimeManager.connect("event_19pm", self._on_event_7pm)
	TimeManager.connect("event_20pm", self._on_event_8pm)
	TimeManager.connect("event_21pm", self._on_event_9pm)
	TimeManager.connect("event_22pm", self._on_event_10pm)
	TimeManager.connect("event_23pm", self._on_event_11pm)

func populate_item_list(player_inventory: InventoryResource) -> void:
	inventory_interface.item_list.clear()
	for item in player_inventory.items:
		if item:
			inventory_interface.item_list.add_item("", item.visual, true)
			var index := int(inventory_interface.item_list.item_count) - 1
			inventory_interface.item_list.set_item_metadata(index, item)
		else:
			inventory_interface.item_list.add_item("", UNKNOWN_ICON, true)
			print("Null item added.")

func _process(delta):
	frames_label.text = "Frames per second is " + "%.5f" % (1/delta)
	scene_label.text = "Current level: " + current_level
	# item_label.text = "Item: " + player.hold_socket.item_id
	cash_label.text = "Cash: " + str(Global.player_cash)
	label_cash.text = "Cash: " + str(Global.player_cash)
	
	if Global.shop_open:
		shop_status_label.text = "Shop is now open."
	else:
		shop_status_label.text = "Shop is now closed."

func _allow_purchase() -> void:
	player_around_shop = true

func _disallow_purchase() -> void: 
	player_around_shop = false
	shop_interface.visible = false

func _allow_itemgrab() -> void:
	player_around_fridge = true

func _disallow_itemgrab() -> void:
	player_around_fridge = false

func _on_time_changed(hour, minute):
	var am_pm = "AM"
	var display_hour = hour
	if hour == 0:
		display_hour = 12
	elif hour >= 12:
		am_pm = "PM"
		if hour > 12:
			display_hour = hour - 12
	
	var minute_str = "%02d" % minute
	time_label.text = "%d:%s %s" % [display_hour, minute_str, am_pm]

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		debug_panel.visible = !debug_panel.visible
		
	elif event.is_action_pressed("tab"):
		inventory_interface.visible = true
		populate_item_list(Global.player_inventory)
		
	elif event.is_action_released("tab"):
		inventory_interface.visible = false
		
	elif player_around_shop and event.is_action_pressed("interact"):
		shop_interface.visible = !shop_interface.visible
		
	elif player_around_fridge and event.is_action_pressed("interact"):
		print("FridgeInterface was called.")
		kitchen_storage_interface.visible = !kitchen_storage_interface.visible
		
	else:
		return

func remove_current_scene() -> void:
	for child in world.get_children():
		if child.is_in_group("Levels"):
			child.queue_free()
			SignalBus.player_around_shop.disconnect(_allow_purchase)
			SignalBus.player_not_around_shop.disconnect(_disallow_purchase)

func _start():
	remove_current_scene()
	debug_panel.visible = true
	current_level = "Start"
	current_scene = start.instantiate()
	current_scene.add_to_group("Levels")
	world.add_child(current_scene)

func _on_the_outskirts_pressed():
	remove_current_scene()
	debug_panel.visible = false
	current_level = "The Outskirts"
	current_scene = outskirts.instantiate()
	SignalBus.player_around_shop.connect(_allow_purchase)
	SignalBus.player_not_around_shop.connect(_disallow_purchase)
	current_scene.add_to_group("Levels")
	world.add_child(current_scene)

func _on_the_restaurent_pressed():
	remove_current_scene()
	debug_panel.visible = false
	current_level = "The Restaurent"
	current_scene = restaurent.instantiate()
	current_scene.add_to_group("Levels")
	world.add_child(current_scene)
	SignalBus.player_around_fridge.connect(_allow_itemgrab)
	SignalBus.player_not_around_fridge.connect(_disallow_itemgrab)

func _on_the_store_pressed():
	remove_current_scene()
	debug_panel.visible = false
	current_level = "The Restaurent"
	current_scene = store.instantiate()
	SignalBus.player_around_shop.connect(_allow_purchase)
	SignalBus.player_not_around_shop.connect(_disallow_purchase)
	current_scene.add_to_group("Levels")
	world.add_child(current_scene)

func _on_exit_pressed():
	get_tree().quit()

func _on_restart_pressed():
	if current_level != "Start":
		# remove_current_scene()
		pass


func _on_shop_back_button_pressed():
	shop_interface.visible = false

func _on_shop_purchase_button_pressed():
	if shop_interface.selected_item != null:
		if Global.player_cash >= shop_interface.selected_item.cost:
			Global.player_cash -= shop_interface.selected_item.cost
			label_cash.text = "Cash: " + str(Global.player_cash)
			Global.player_inventory.add_item(shop_interface.selected_item)
			
			print("Successfully Purchased the " + shop_interface.selected_item.id)
		else:
			print("Player do not have enough money to buy the item.")

func _on_fridge_back_pressed():
	kitchen_storage_interface.visible = false

func _on_fridge_grab_pressed():
	if Global.player.hold_socket.has_item == false:
		Global.player.hold_socket.grab_item(kitchen_storage_interface.selected_item.id)
		kitchen_storage_interface.visible = false
	else:
		print("I dunno what happened.")

# Event Flag Signals.
func _on_event_0am() -> void:
	print("Midnight.")
	TimeManager.skip_to_time(6, 0)

func _on_event_1am() -> void:
	pass

func _on_event_2am() -> void:
	pass

func _on_event_3am() -> void:
	pass

func _on_event_4am() -> void:
	pass

func _on_event_5am() -> void:
	Global.shop_open = false

func _on_event_6am() -> void:
	pass

func _on_event_7am() -> void:
	pass

func _on_event_8am() -> void:
	pass

func _on_event_9am() -> void:
	Global.shop_open = true
	if current_level == "The Restaurent":
		current_scene.find_child("AudioStreamPlayer").playing = true

func _on_event_10am() -> void:
	pass

func _on_event_11am() -> void:
	pass

func _on_event_12pm() -> void:
	pass

func _on_event_1pm() -> void:
	pass

func _on_event_2pm() -> void:
	pass

func _on_event_3pm() -> void:
	pass

func _on_event_4pm() -> void:
	pass

func _on_event_5pm() -> void:
	pass

func _on_event_6pm() -> void:
	pass

func _on_event_7pm() -> void:
	pass

func _on_event_8pm() -> void:
	pass

func _on_event_9pm() -> void:
	pass

func _on_event_10pm() -> void:
	pass

func _on_event_11pm() -> void:
	pass
