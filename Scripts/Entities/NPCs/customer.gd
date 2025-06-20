extends CharacterBody3D

@export var customer: CustomerResource

signal request_seating(customer: CharacterBody3D)

# Enum for Customer States
enum State {
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
enum WaitType {
	NONE,
	FOR_FOOD,
	FOR_THANKS
}

# Member variables
var level: Node = null
@onready var nav_agent: NavigationAgent3D
@onready var entry_point: Node3D
@onready var timer: Timer = $Timer
@onready var label = $Label3D
@onready var item_popup_label: Sprite3D = $PopUp/Sprite3D
@onready var item_popup_anim: AnimationPlayer = $PopUp/AnimationPlayer

# Handling the Orders.
var current_state: State = State.SPAWN
var state_timer: float = 0.0
var has_ordered: bool = false
var order_item
var food_received: bool = false
var chair_position: Vector3
var current_chair: StaticBody3D = null
var current_wait_type: WaitType = WaitType.NONE

func _ready():
	add_to_group("Customer")
	add_to_group("Interactable")
	level = get_parent()
	
	nav_agent = find_child("NavigationAgent3D", true, false)
	entry_point = get_parent().find_child("Door", true, false)
	
	if nav_agent == null: push_error("NavigationAgent3D not found!")
	if entry_point == null: push_error("Door not found!")


func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return
		
	if current_state == State.FIND_CHAIR and global_transform.origin.distance_to(chair_position) < 2:
		set_state(State.SITTING)
		
	if current_state == State.LEAVING:
		if nav_agent.is_navigation_finished() and has_reached_exit():
			print("Customer reached the exit. Emitting signal.")
			emit_signal("customer_ready_to_despawn", self)
			return
		else:
			var next_position = nav_agent.get_next_path_position()
			var direction = (next_position - global_transform.origin).normalized()
			velocity.x = direction.x * 2.0
			velocity.z = direction.z * 2.0
			if not is_on_floor():
				velocity += get_gravity() * delta
			move_and_slide()
		return

	# if global_transform.origin.distance_to(current_chair.global_transform.origin) < 4:
		# nav_agent.is_navigation_finished()
		# set_state(State.SITTING)
		
	var next_position: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = (next_position - global_transform.origin).normalized()
	velocity.x = direction.x * 2.0
	velocity.z = direction.z * 2.0
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func set_state(new_state: State) -> void:
	current_state = new_state
	state_timer = 0.0
	
	match new_state:
		State.FIND_CHAIR:
			label.text = "Finding Chair"
			walk_to_chair()
		State.SITTING:
			label.text = "Sitting"
			global_transform.origin = Vector3(0, 0.5, 0)+ current_chair.get_node("SeatPoint").global_transform.origin
			set_state(State.WAITING)
			
		State.ORDERING:
			pass
			
		State.WAITING:
			match current_wait_type:
				WaitType.NONE:
					label.text = "Ordering"
					timer.start(5.0)
					if has_ordered: 
						current_wait_type = WaitType.FOR_FOOD
					else:
						pass
					show_order_popup()
				WaitType.FOR_FOOD:
					label.text = "Waiting For Food"
					timer.start(5.0)
				WaitType.FOR_THANKS:
					label.text = "Waiting For Bill"
					timer.start(5.0)
					
		State.EATING:
			pass
			
		State.IMPATIENT:
			label.text = "Impatient"
			timer.start(5.0)
			
		State.LEAVING:
			label.text = "Walking to Exit"
			walk_to_exit()


func find_nearest_available_chair() -> Node3D:
	var chairs_root: Node = get_parent().find_child("ChairsRoot")
	var nearest_chair: StaticBody3D = null
	var nearest_dist: float = INF
	
	if chairs_root == null:
		print("ERROR: chairs_root is null")
		return
	
	for child in chairs_root.get_children():
		if child is Node3D and child.has_method("is_taken") and not child.call("is_taken"):
			var seat_pos: Vector3 = child.get_node("SeatPoint").global_transform.origin
			var dist: float = global_transform.origin.distance_to(seat_pos)
			if dist < nearest_dist:
				nearest_dist = dist
				nearest_chair = child
				
	if nearest_chair:
		current_chair = nearest_chair
		nearest_chair.call("set_taken", true)
		return nearest_chair
		
	return

# Leaving the restaurant 
func walk_to_exit():
	if current_chair:
		current_chair.call("set_taken", false)
		current_chair = null
	nav_agent.target_position = entry_point.global_transform.origin
	current_state = State.LEAVING
	label.text = "Leaving"

func has_reached_exit(threshold := 1.5) -> bool:
	return global_transform.origin.distance_to(entry_point.global_transform.origin) <= threshold

# Finding available chair
func walk_to_chair() -> void:
	emit_signal("request_seating", self)
	current_chair = find_nearest_available_chair()
	if current_chair == null:
		set_state(State.LEAVING)
	else:
		chair_position = current_chair.get_node("SeatPoint").global_transform.origin
		nav_agent.target_position = chair_position

func show_order_popup() -> void:
	print("Customer: I'd like to order!")
	customer = assign_random_customer_data(level.customer_resources, level.food_resources)
	current_wait_type = WaitType.FOR_FOOD
	item_popup_label.texture = customer.favored_dish.item_visual
	item_popup_anim.play("wavy")

func assign_random_customer_data(customer_resources, food_resources):
	var chosen_customer = customer_resources[randi() % customer_resources.size()]
	
	# Randomize favored/disfavored dishes from the food list.
	chosen_customer.favored_dish = food_resources[randi() % food_resources.size()]
	chosen_customer.disfavored_dish = food_resources[randi() % food_resources.size()]
	
	# print("Customer: ", chosen_customer.name)
	# print("Order: ", chosen_customer.favored_dish.item_info)
	# print("Dislikes: ", chosen_customer.disfavored_dish.item_info)
	return chosen_customer

func _on_timer_timeout():
	match current_state:
		State.SITTING:
			set_state(State.ORDERING)
		
		State.WAITING:
			set_state(State.IMPATIENT)
		
		State.EATING:
			current_wait_type = WaitType.FOR_THANKS
			set_state(State.WAITING)
		
		State.IMPATIENT:
			set_state(State.LEAVING)

# TODO -> Undefined Functions.
func show_impatient_effect() -> void:
	# print("Customer is getting impatient!")
	pass

func play_sit_animation() -> void:
	pass
