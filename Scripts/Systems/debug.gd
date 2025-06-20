extends PanelContainer

@onready var held_item_label = $Panel/VBoxContainer/held_item
@onready var item_status_label = $Panel/VBoxContainer/item_status
@onready var customers_label = $Panel/VBoxContainer/customers
@onready var frames_per_second_label = $Panel/VBoxContainer/frames_per_second

@onready var hold_socket = $"../SubViewportContainer/SubViewport/Main/Player/HoldSocket"
@onready var level = $"../SubViewportContainer/SubViewport/Main"

@onready var clock_label = %ClockLabel
@onready var points = %Points

func _ready():
	# Connect to the global time_changed signal
	# TimeManager.connect("time_changed", self._on_time_changed)
	
	%Points.text = "Profits: " 

var item_status_variable: String = ""
var customer_variable: int = 0
var held_item_variable: String

func _process(delta):
	
	if !hold_socket.has_item:
		held_item_variable = "nothing"
		item_status_label.hide()
	else:
		item_status_label.visible = true
		held_item_variable = str(hold_socket.item_id)
		var item = Global.get_item_data(hold_socket.item_id)
		if item.can_be_processed:
			item_status_variable = "raw"
		else:
			item_status_variable = "cooked"
	
	
	held_item_label.text = "Currently holding " + held_item_variable + "."
	customers_label.text = "Customer visited " + str(customer_variable) + "."
	frames_per_second_label.text = "Frames per second is " + "%.5f" % (1/delta)
	item_status_label.text = "Item is " + item_status_variable + "."

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
	clock_label.text = "%d:%s %s" % [display_hour, minute_str, am_pm]
