class_name SpawnerSystem
extends Node

@export var customer: PackedScene
@onready var timer = %Timer
@onready var door: Node3D = %Door

var shop_open: bool = true
@onready var main = $"../.."

func _ready():
	timer.start(1)

# Also assigns random attributes, commented out.
func spawn_customer():
	# $Debug.customer_variable += 1
	if Global.shop_open:
		var customer_instance: CharacterBody3D = customer.instantiate()
		if customer_instance:
			main.add_child(customer_instance)
			customer_instance.set_state(customer_instance.states.FIND_CHAIR)
			customer_instance.global_transform.origin = door.global_transform.origin
			customer_instance.connect("satisfied", Callable(self, "point_increase"))
			customer_instance.connect("dissatisfied", Callable(self, "point_decrease"))
			timer.start(10.0)
		else:
			return

func point_increase():
	Global.player_cash += 250
	#%Points.text = "Profits: " + str($"../../Player".points)

func point_decrease():
	Global.player_cash -= 50
	#%Points.text = "Profits: " + str($"../../Player".points)

func _on_timer_timeout():
	if shop_open:
		spawn_customer()
