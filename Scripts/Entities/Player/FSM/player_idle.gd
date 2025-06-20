extends State

func enter():
	# await owner.ready
	owner_fsm.velocity = Vector3.ZERO
	owner_fsm.animation_player.play("idle")
	print("Player has entered into idle state.")

func physics_update(_delta):
	if owner_fsm.is_on_floor() and owner_fsm.get_input_direction().length() >= 0.2:
		Transition.emit(self, "PlayerMoving")
		
	elif owner_fsm.is_on_floor() and Input.is_action_just_pressed("space"):
		Transition.emit(self, "PlayerJumping")
			
	elif not owner_fsm.raycast.is_colliding() and not owner_fsm.is_on_floor():
		Transition.emit(self, "PlayerFalling")
		
	elif Input.is_action_just_pressed("interact"):
		Transition.emit(self, "PlayerPickUp")
