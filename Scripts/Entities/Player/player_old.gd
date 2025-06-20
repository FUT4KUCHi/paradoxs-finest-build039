extends CharacterBody3D

@export_group("Movement")
@export var movement_speed: float = 5.00
@export var rotation_speed: float = 12.00
@export var acceleration: float = 0.1
@export var deceleration: float = 0.25
@export var jump_impulse: float = 6.50

var movement_input_vector = Vector2.ZERO
var last_movement_direction = Vector3.BACK
var move_direction

# FiniteStateMachine
enum states {
	IDLE,
	MOVING,
	AERIAL,
	FLOATING
}

var current_state

@onready var player_model = $Skin # Player Model
@onready var hold_socket: HoldSocket = $HoldSocket # Item Socket
@onready var radar_component = $RadarComponent # RadarComponent
@onready var animation_player = $Skin/AnimationPlayer

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var level
var nearby_stations
var points: int = 0

func _handle_indicators() -> void:
	var target = radar_component.find_nearby_target("Interactable", 3.0)
	if target == null:
		return
		
	if target.is_in_group("Table") or target.is_in_group("Station"):
		target.indicator.visible = false
		target.animation_player.stop()
		var distance = global_position.distance_to(target.global_position)
		if distance < 2:
			target.indicator.visible = true
			target.animation_player.play("DropIndicator")
		else:
			pass

func _ready():
	add_to_group("Player")
	player_model = find_child("Skin", true, false)
	level = get_tree().current_scene

func _physics_process(delta):
	_handle_movement(delta)
	
	if Input.is_action_just_pressed("interact"):
		_handle_interaction()
	
	# Jump, Gravity
	if is_on_floor() and Input.is_action_just_pressed("space"):
		# velocity.y += jump_impulse
		pass
		
	elif not is_on_floor():
		velocity.y -= gravity * delta
	
func set_state(new_state):
	current_state = new_state
	match current_state:
		states.MOVING:
			animation_player.play("sprint")
		states.IDLE:
			animation_player.play("idle")
		states.AERIAL:
			animation_player.play("fall")

func _handle_movement(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	move_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor() and velocity.length() > 0.2:
		set_state(states.MOVING)
	elif is_on_floor():
		set_state(states.IDLE)
	else:
		set_state(states.AERIAL)
	
	if move_direction:
		velocity.x = lerp(velocity.x, move_direction.x * movement_speed, acceleration)
		velocity.z = lerp(velocity.z, move_direction.z * movement_speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)
		
	if move_direction.length() > 0.2:
		last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(last_movement_direction, Vector3.UP)
	player_model.global_rotation.y = lerp_angle(player_model.rotation.y, target_angle, rotation_speed * delta)
	
	move_and_slide()

func _handle_customer(target) -> void:
	if target.current_state == 2:
		target.set_state(target.State.ORDERING)
	if target.current_state == target.State.ORDERING:
		target.set_state(target.State.WAITING)
		target.has_ordered = true
	if target.current_state == target.State.IMPATIENT:
		target.set_state(target.State.WAITING)

func _handle_interaction():
	var target = radar_component.find_nearby_target("Interactable", 2.0)
	if target == null: 
		return
	
	if target.is_in_group("Customer"):
		_handle_customer(target)
	
	if target.is_in_group("Table"):
		if not hold_socket.has_item and not target.has_item:
			return
		elif hold_socket.has_item and not target.has_item:
			target.add_item(hold_socket.item_id)
			hold_socket.drop_item()
		elif not hold_socket.has_item:
			hold_socket.grab_item(target.on_interact())
			target.remove_item()
		else:
			pass
			
		# target.on_interact(hold_socket.item_id, hold_socket)
	
	if target.is_in_group("TrashCan"):
		hold_socket.drop_item()
		pass
	
	if target.is_in_group("Fridge") and hold_socket.has_item == false:
		hold_socket.grab_item(target.on_interact())
	
	if target.is_in_group("IngredientBox") and hold_socket.has_item == false:
		hold_socket.grab_item(target.on_interact())
	
	if target.is_in_group("Station"):
		if hold_socket.has_item:
			var item = Global.get_item_data(hold_socket.item_id)
			if item.can_be_processed and target.has_item == false:
				target.add_item(hold_socket.item_id)
				hold_socket.drop_item()
			else:
				print("Food is already cooked.")
				return
		elif not hold_socket.has_item:
			if target.has_item: 
				hold_socket.grab_item(target.on_interact())
				target.remove_item()
			else:
				print("The pan is empty.")
				return
	
	if target.is_in_group("SushiTable"):
		if hold_socket.has_item:
			var item = Global.get_item_data(hold_socket.item_id)
			if item.can_be_processed and target.has_item == false and not item.id not in target.required_ingredients:
				target.add_item(item.id)
				hold_socket.drop_item()
			else:
				print("Wrong Ingredient or food is already cooked.")
		elif not hold_socket.has_item:
			if target.has_item: 
				hold_socket.grab_item(target.on_interact())
				target.remove_item()
		else:
			print("YEEEEE")
			return
