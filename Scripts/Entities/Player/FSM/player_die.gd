extends State

func enter():
	print("Player has died.")
	owner_fsm.velocity = Vector3.ZERO
	owner_fsm.animation_player.play("die")
	await get_tree().create_timer(5.0).timeout
	Transition.emit(self, "PlayerIdle")
