extends State

func enter():
	owner_fsm.animation_player.play("fall")
	print("Player has entered into falling state.")

func physics_update(_delta):
	if owner_fsm.is_on_floor():
		Transition.emit(self, "PlayerDie")
