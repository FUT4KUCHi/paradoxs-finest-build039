extends Control

@onready var clock_label = %ClockLabel
@onready var points = %Points

func _ready():
	# Connect to the global time_changed signal
	Global.TimeManager.connect("time_changed", self._on_time_changed)

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
