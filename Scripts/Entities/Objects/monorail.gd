extends Node3D

var direction: int = 1
var speed: float = 1.00

@onready var path_follow = $Path3D/PathFollow3D
@onready var marker3D = $Path3D/PathFollow3D/ElevatorMesh/Marker3D

func _ready():
	add_to_group("Interactable")
	add_to_group("Monorail")

func _process(delta):
	if path_follow.progress_ratio >= 0:
		direction = 2
	if path_follow.progress_ratio >= 1:
		direction = -2
		
	path_follow.progress += delta * direction
