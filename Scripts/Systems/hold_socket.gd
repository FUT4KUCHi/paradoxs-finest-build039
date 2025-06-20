class_name HoldSocket extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var has_item: bool = false
var item_id: String = ""

func _physics_process(_delta):
	if has_item:
		$AnimationPlayer.play("rotation")
	else:
		$AnimationPlayer.stop()

func _ready():
	pass

func grab_item(id: String) -> void:
	has_item = true
	item_id = id
	instantiate_item_scene()

func drop_item():
	has_item = false
	item_id = ""
	remove_item_scene()

func remove_item_scene():
	for child in get_children():
		if child.is_in_group("Item"):
			child.queue_free()

func instantiate_item_scene() -> void:
	var scene = Global.get_item_data(item_id).scene
	var instance = scene.instantiate()
	instance.scale = Vector3(0, 0, 0)
	var tween = create_tween()
	tween.tween_property(instance, "scale", Vector3(1, 1, 1), 0.5)
	instance.add_to_group("Item")
	add_child(instance)
