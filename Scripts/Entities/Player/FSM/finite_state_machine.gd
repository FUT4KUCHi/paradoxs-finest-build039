class_name FiniteStateMachine extends Node

@export var CURRENT_STATE: State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.owner_fsm = get_parent()
			child.Transition.connect(on_child_transition)
		else:
			push_warning("State Machine contains incompatible child node")
	
	await owner.ready
	CURRENT_STATE.enter()

func on_child_transition(state: State, new_state_name: StringName) -> void:
	if state != CURRENT_STATE:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if CURRENT_STATE:
		CURRENT_STATE.exit()
	
	new_state.enter()
	CURRENT_STATE = new_state

func _process(delta):
	if CURRENT_STATE: CURRENT_STATE.update(delta)

func _physics_process(delta):
	if CURRENT_STATE: CURRENT_STATE.physics_update(delta)
