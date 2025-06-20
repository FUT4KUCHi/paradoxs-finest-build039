extends CharacterBody3D

@export var customer_resource: CustomerResource
var customer

signal satisfied
signal dissatisfied

# Enum for Customer States
enum states {
	SPAWN,               # State where the customer spawns.
	FIND_CHAIR,          # State where the customer finds an available chair.
	SITTING,             # State where the customer sits. 
	ORDERING,            # State where the customer places the order.
	WAITING,             # State where the customer waits.
	EATING,              # State where the customer eats.
	IMPATIENT,           # State where the customer gets impatient.
	LEAVING              # State where the customer leavves.
}

# Enum for WaitTypes
enum STANDBY {
	NONE,
	EATING,
	FOR_THANKS
}

# Member Variables
@onready var timer: Timer = $Timer
@onready var state_label = $Label3D
@onready var item_popup_label: Sprite3D = $PopUp/Sprite3D
@onready var item_popup_anim: AnimationPlayer = $PopUp/AnimationPlayer
@onready var nav_agent: NavigationAgent3D
@onready var entry_point: Node3D
@onready var level: Node

# Components
@onready var radar_component = $RadarComponent

# State Machine Variables
var current_state = states.SPAWN
var current_wait_type: STANDBY = STANDBY.NONE
var state_timer: float = 0.0

# Member Variables of State: ORDERING
var has_ordered: bool = false
var food_received: bool = false
var order_item: ItemResource

# Member Variables of State: SITTING
@onready var seating_system: SeatingSystem = get_tree().get_root().find_child("SeatingSystem", true, false)
@onready var serving_system: ServingSystem = get_tree().get_root().find_child("ServingSystem", true, false)
var chair_position: Vector3
var current_chair = null
var current_table: Table = null

func _ready():
	add_to_group("Customer")
	add_to_group("Interactable")
	
	customer = assign_random_customer_data(Global.customer_registry, Global.dishes_registry)
	nav_agent = find_child("NavigationAgent3D", true, false)
	entry_point = get_parent().find_child("Door", true, false)

func _physics_process(delta):
	# if current_table: print("Current table: ", current_table, ". Item present: ", current_table.item_present)
	# print(radar_component.find_nearby_target("Table", 3.0))
	
	if nav_agent.is_navigation_finished() and states.LEAVING and global_position.distance_to(entry_point.global_position) < 2:
		queue_free()
	
	handle_movement(delta)
	check_arrival()
	state_label.text = str(current_state)

func set_state(new_state) -> void:
	current_state = new_state
	state_timer = 0.0
	
	match new_state:
		states.SPAWN:
			pass
			
		states.FIND_CHAIR:
			if find_unoccupied_chair():
				$PopUp/AnimationPlayer.play("joy")
				walk_to_chair()
				
		states.SITTING:
			try_sitting()
			
		states.ORDERING:
			show_order_popup()
			
		states.EATING:
			# $PopUp/AnimationPlayer.play("excitement")
			$PopUp/AnimationPlayer.play("eating")
			
		states.IMPATIENT:
			$PopUp/AnimationPlayer.play("anger")
			
		states.LEAVING:
			$PopUp/AnimationPlayer.play("heartbroken")
			walk_to_exit()
			
		states.WAITING:
			$PopUp/AnimationPlayer.play("waiting")
			match current_wait_type:
				STANDBY.NONE:
					pass
				STANDBY.EATING:
					pass
				STANDBY.FOR_THANKS:
					pass

# Helper Functions.

func show_order_popup() -> void:
	current_wait_type = STANDBY.NONE
	order_item = customer.order
	item_popup_label.texture = customer.order.visual
	item_popup_anim.play("wavy")
	has_ordered = true
	timer.start(25.0)
	set_state(states.WAITING)

func check_arrival() -> void:
	if current_state == states.WAITING or current_state == states.IMPATIENT:
		check_order_item()
		
	if current_state == states.FIND_CHAIR and chair_position != Vector3.ZERO:
		if global_position.distance_to(current_chair.global_position) < 2:
			current_chair.call("set_taken", true)
			current_table = radar_component.find_nearby_target("Table", 3.0)
			set_state(states.SITTING)
	
	elif current_state == states.LEAVING and entry_point:
		if global_position.distance_to(entry_point.global_position) < 1.5:
			queue_free()

func check_order_item() -> void:
	if has_ordered and current_table.has_item:
		if current_table.stored_item_id == order_item.id:
			print("Satisfied.")
			set_state(states.EATING)
			timer.start(5)
			
		elif current_table.stored_item_id != order_item.id:
			print("Order wasn't correct, not satisfied.")
			set_state(states.LEAVING)
			emit_signal("dissatisfied")
	else:
		pass

func find_unoccupied_chair() -> Node3D:
	var chairs_root: Node = get_parent().find_child("ChairsRoot")
	var nearest_chair: StaticBody3D = null
	var nearest_dist: float = INF
	
	if chairs_root == null:
		print("ERROR: chairs_root is null")
		return
	
	for child in chairs_root.get_children():
		if child is StaticBody3D and child.has_method("is_taken") and not child.call("is_taken"):
			var seat_pos: Vector3 = child.get_node("SeatPoint").global_transform.origin
			var dist: float = global_transform.origin.distance_to(seat_pos)
			if dist < nearest_dist:
				nearest_dist = dist
				nearest_chair = child
	if nearest_chair:
		current_chair = nearest_chair
		return nearest_chair
	return null

func assign_random_customer_data(customer_registry: Dictionary, food_registry: Dictionary) -> CustomerResource:
	var customer_keys = customer_registry.keys()
	var food_keys = food_registry.keys()

	var chosen_customer_id = customer_keys[randi() % customer_keys.size()]
	var chosen_customer: CustomerResource = customer_registry[chosen_customer_id].duplicate() # Avoid overwriting original

	# Assigns the order dishes randomly.
	var chosen_meal_id = food_keys[randi() % food_keys.size()]
	var chosen_meal = food_registry[chosen_meal_id].duplicate()
	chosen_customer.order = chosen_meal

	return chosen_customer

func assign_table() -> Node3D:
	var nearest_table: Node3D = null
	var nearest_dist: float = 3.0
	var customer_pos: Vector3 = current_chair.get_node("SeatPoint").global_transform.origin

	for table in serving_system.tables:
		if table.is_in_group("Table") and not table.get("taken"):
			var snap_point = table.snap_point.global_transform.origin
			var dist = customer_pos.distance_to(snap_point)
			if dist < nearest_dist:
				nearest_table = table
				nearest_dist = dist
	if nearest_table:
		current_table = nearest_table
		current_table.set("taken", true)
		nearest_table.assign_customer_to_table(self)
		return current_table
	return
	
func walk_to_exit() -> void:
	current_state = states.LEAVING
	seating_system.release_chair(current_chair)
	nav_agent.target_position = entry_point.global_transform.origin
	serving_system.release_tables(current_table)
	$PopUp.hide()

func walk_to_chair() -> void:
	current_chair = seating_system.request_available_chair()
	if current_chair:
		chair_position = current_chair.global_transform.origin
		nav_agent.target_position = chair_position
	else:
		return

func try_sitting() -> void:
	if current_chair:
		global_transform.origin = Vector3(0, 1, 0) + current_chair.get_node("SeatPoint").global_transform.origin
		var table = radar_component.find_nearby_target("Table", 3.0)
		# var table = serving_system.request_available_table()
		if table:
			current_table = table
			current_table.assign_customer_to_table(self)
			timer.start(1)

func _on_timer_timeout():
	match current_state:
		states.SITTING:
			set_state(states.ORDERING)
		
		states.ORDERING:
			set_state(states.WAITING)
			
		states.WAITING:
			set_state(states.IMPATIENT)
		
		states.EATING: 
			queue_free()
			current_table.remove_item()
			seating_system.release_chair(current_chair)
			emit_signal("satisfied")
			# current_wait_type = STANDBY.FOR_THANKS
			# set_state(states.WAITING)
		
		states.IMPATIENT:
			set_state(states.LEAVING)

func handle_movement(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if nav_agent.is_navigation_finished():
		return
	
	var next_position: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = (next_position - global_transform.origin).normalized() 
	
	#nav_agent.set_velocity_forced(direction)
	velocity.x = direction.x * 2.0
	velocity.z = direction.z * 2.0
	#velocity = velocity.move_toward(direction, 2.0)
	move_and_slide()

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
