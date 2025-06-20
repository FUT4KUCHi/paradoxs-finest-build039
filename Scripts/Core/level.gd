class_name Level
extends Node

@export var customer: PackedScene

func _ready():
	add_to_group("Levels")
	Global._register_customers()
	Global._register_dishes()
	Global._register_ingredients()
	Global._register_items()
	$AnimationPlayer.play("daynight_cycle")

func _on_kill_box_body_entered(body):
	if body.is_in_group("Player"):
		body.global_position = Vector3(14, 3, 7.5)
