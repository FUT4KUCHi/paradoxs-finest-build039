extends State

func enter():
	owner_fsm.animation_player.play("pick-up")
	print("Player has entered into pickup state.")

func physics_update(_delta):
	if animation_finished():
		Transition.emit(self, "PlayerIdle")

func animation_finished() -> bool:
	return true
