extends State

@export_group("Movement")
@export var movement_speed: float = 5.00
@export var rotation_speed: float = 12.00
@export var acceleration: float = 0.1
@export var deceleration: float = 3.5
@export var player_model: Node3D
var last_movement_direction = Vector3.BACK

func enter():
	print("Player has entered into moving state.")
	if owner_fsm.is_on_floor():
		owner_fsm.animation_player.play("sprint")

func physics_update(delta):
	# Exit conditions.
	if owner_fsm.get_input_direction().length() <= 0:
		Transition.emit(self, "PlayerIdle")
	if owner_fsm.is_on_floor() and Input.is_action_just_pressed("space"):
		Transition.emit(self, "PlayerJumping")
	#if not owner_fsm.raycast.is_colliding():
		#Transition.emit(self, "PlayerFalling")
	
	_handle_movement(delta)

func _handle_movement(delta):
	if !owner_fsm.camera_transition:
		var target_angle := Vector3.BACK.signed_angle_to(last_movement_direction, Vector3.UP)
		player_model.global_rotation.y = lerp_angle(player_model.rotation.y, target_angle, rotation_speed * delta)
	
	var input_dir = owner_fsm.get_input_direction()
	var move_direction = (owner_fsm.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if move_direction:
		owner_fsm.velocity.x = lerp(owner_fsm.velocity.x, move_direction.x * movement_speed, acceleration)
		owner_fsm.velocity.z = lerp(owner_fsm.velocity.z, move_direction.z * movement_speed, acceleration)
		# owner_fsm.velocity = invert_controls(owner_fsm.velocity)
	else:
		owner_fsm.velocity.x = move_toward(owner_fsm.velocity.x, 0, deceleration) 
		owner_fsm.velocity.z = move_toward(owner_fsm.velocity.z, 0, deceleration)
	
	if move_direction.length() > 0.2:
		last_movement_direction = move_direction
