extends Node

# Declare signals for every hour of the day
signal time_changed(hour, minute)
signal event_0am()
signal event_1am()
signal event_2am()
signal event_3am()
signal event_4am()
signal event_5am()
signal event_6am()
signal event_7am()
signal event_8am()
signal event_9am()
signal event_10am()
signal event_11am()
signal event_12pm()
signal event_13pm()
signal event_14pm()
signal event_15pm()
signal event_16pm()
signal event_17pm()
signal event_18pm()
signal event_19pm()
signal event_20pm()
signal event_21pm()
signal event_22pm()
signal event_23pm()

var time_in_minutes : int = 0
var time_speed : float = 60.0

var hour
var minute
var second

var time_scale := 32.0
var in_game_time := 0.0
const SECONDS_IN_DAY := 24 * 60 * 60

# Auto-generate time_events for each hour
var time_events := {}

func _ready():
	for h in range(24):
		var key := str(h) + ":0"
		var sig := "event_%dam" % h if h < 12 else "event_%dpm" % h
		time_events[key] = { "signal": sig, "triggered": false }

func _physics_process(delta):
	in_game_time += delta * time_scale * 5
	in_game_time = fmod(in_game_time, SECONDS_IN_DAY)
	
	hour = int(in_game_time) / 3600
	minute = (int(in_game_time) % 3600) / 60
	# second = int(in_game_time) % 60

	emit_signal("time_changed", hour, minute)

	for time_key in time_events.keys():
		var parts = time_key.split(":")
		var event_hour = int(parts[0])
		var event_minute = int(parts[1])
		var event_data = time_events[time_key]

		if hour == event_hour and minute == event_minute:
			if not event_data["triggered"]:
				emit_signal(event_data["signal"])
				print("Triggered:", event_data["signal"])
				event_data["triggered"] = true
		else:
			event_data["triggered"] = false

func skip_to_time(target_hour: int, target_minute: int = 0):
	in_game_time = (target_hour * 3600) + (target_minute * 60)
	in_game_time = fmod(in_game_time, SECONDS_IN_DAY)
	
	# Optionally update hour, minute, second immediately
	hour = target_hour
	minute = target_minute
	second = 0
	emit_signal("time_changed", hour, minute)
	print("Skipped to: %02d:%02d" % [hour, minute])

func _suppress_unused_signal_warnings():
	# This tricks the linter into thinking these are used
	if false:
		emit_signal("event_0am")
		emit_signal("event_1am")
		emit_signal("event_2am")
		emit_signal("event_3am")
		emit_signal("event_4am")
		emit_signal("event_5am")
		emit_signal("event_6am")
		emit_signal("event_7am")
		emit_signal("event_8am")
		emit_signal("event_9am")
		emit_signal("event_10am")
		emit_signal("event_11am")
		emit_signal("event_12pm")
		emit_signal("event_13pm")
		emit_signal("event_14pm")
		emit_signal("event_15pm")
		emit_signal("event_16pm")
		emit_signal("event_17pm")
		emit_signal("event_18pm")
		emit_signal("event_19pm")
		emit_signal("event_20pm")
		emit_signal("event_21pm")
		emit_signal("event_22pm")
		emit_signal("event_23pm")
