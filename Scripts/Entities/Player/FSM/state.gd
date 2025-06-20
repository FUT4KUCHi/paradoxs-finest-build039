class_name State extends Node

var owner_fsm: CharacterBody3D = null
signal Transition(new_state_name: StringName)

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass 
