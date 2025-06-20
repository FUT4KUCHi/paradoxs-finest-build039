class_name Player extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $Skin/AnimationPlayer
@onready var raycast: RayCast3D = $RayCast3D
@onready var radar_component: Node3D = $RadarComponent
@export var hold_socket: Node3D = null

@export_group("Camera Rig")
@onready var camera_rig = $CameraRig
@onready var main_camera = $CameraRig/MainCamera
@onready var bottom_right = $CameraRig/BottomRight
@onready var bottom_left = $CameraRig/BottomLeft
@onready var top_left = $CameraRig/TopLeft
@onready var top_right = $CameraRig/TopRight
@onready var transition_timer = $CameraRig/TransitionTimer
var camera_transition: bool = false
var active_camera: Camera3D
var current_orientation: CameraOrientation = CameraOrientation.BOTTOM_RIGHT

var input_direction: Vector2
var input_blocked: bool = false
var inventory: InventoryResource = InventoryResource.new()

enum CameraOrientation {
	BOTTOM_RIGHT,
	BOTTOM_LEFT,
	TOP_RIGHT,
	TOP_LEFT
}

func _ready():
	Global.player = self
	add_to_group("Player")

func toggle_flashlight():
	if $Skin/SpotLight3D.visible:
		$Skin/SpotLight3D.visible = false
	elif $Skin/SpotLight3D.visible == false:
		$Skin/SpotLight3D.visible = true

func _physics_process(delta):
	if !camera_transition:
		move_and_slide()
	#else:
		#var direction = Vector3.FORWARD
		#velocity = direction * 2
		#move_and_slide()
	
	apply_gravity(delta)
	
	if Input.is_action_just_pressed("interact"):
		_handle_interaction()
	
	if Input.is_action_just_pressed("F"):
		toggle_flashlight()


# Camera Transition System.
func transition_camera(to: Camera3D) -> void:
	var tween = create_tween()
	
	camera_transition = true
	input_blocked = true
	
	# tween.set_parallel(true)
	tween.tween_property(main_camera, "global_transform", to.global_transform, 2).set_trans(Tween.TRANS_SINE)
	# tween.tween_property(self, "velocity", 1 * Vector3.RIGHT, 2).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(Callable(self, "_look_at_player"))
	# main_camera.global_transform = to.global_transform
	
func _look_at_player():
	main_camera.look_at(global_transform.origin, Vector3.UP)
	camera_transition = false
	input_blocked = false

func _on_bottom_right_body_entered(body):
	if body == self:
		transition_camera(bottom_right)
		current_orientation = CameraOrientation.BOTTOM_RIGHT

func _on_top_right_body_entered(body):
	if body == self:
		transition_camera(top_right)
		current_orientation = CameraOrientation.TOP_RIGHT

func _on_top_left_body_entered(body):
	if body == self:
		transition_camera(top_left)
		current_orientation = CameraOrientation.TOP_LEFT

func _on_bottom_left_body_entered(body):
	if body == self:
		transition_camera(bottom_left)
		current_orientation = CameraOrientation.BOTTOM_LEFT

# Input Reorientation
func get_input_direction() -> Vector2:
	if input_blocked:
		return Vector2.ZERO
	
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	match current_orientation:
		CameraOrientation.BOTTOM_RIGHT:
			return input_direction
		CameraOrientation.BOTTOM_LEFT:
			return Vector2(-input_direction.y, input_direction.x)
		CameraOrientation.TOP_RIGHT:
			return Vector2(input_direction.y, -input_direction.x)
		CameraOrientation.TOP_LEFT:
			return -input_direction
	return Vector2.ZERO

#func _input(_InputEvent) -> void:
	#input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func _handle_customer(target) -> void:
	if target.current_state == 4:
		Dialogic.order_item = target.order_item.name
		Dialogic.start('test_timeline')
		target.item_popup_label.visible = true

func _handle_interaction():
	var target = radar_component.find_nearby_target("Interactable", 2.0)
	if target == null: 
		return
		
	if target.is_in_group("Customer"):
		_handle_customer(target)
		
	if target.is_in_group("Table"):
		if not hold_socket.has_item and not target.has_item:
			return
		elif hold_socket.has_item and not target.has_item:
			target.add_item(hold_socket.item_id)
			hold_socket.drop_item()
		elif not hold_socket.has_item:
			hold_socket.grab_item(target.on_interact())
			target.remove_item()
		
	if target.is_in_group("TrashCan"):
		hold_socket.drop_item()
		
	if target.is_in_group("Fridge") and hold_socket.has_item == false:
		SignalBus.player_around_fridge.emit()
		# hold_socket.grab_item(target.on_interact())
		
	if target.is_in_group("IngredientBox") and hold_socket.has_item == false:
		hold_socket.grab_item(target.on_interact())
		
	if target.is_in_group("Station"):
		if hold_socket.has_item:
			var item = Global.get_item_data(hold_socket.item_id)
			if item.can_be_processed and target.has_item == false:
				target.add_item(hold_socket.item_id)
				hold_socket.drop_item()
			else:
				print("Food is already cooked.")
				return
		elif not hold_socket.has_item:
			if target.has_item: 
				hold_socket.grab_item(target.on_interact())
				target.remove_item()
			else:
				print("The pan is empty.")
				return
				
	if target.is_in_group("SushiTable"):
		if hold_socket.has_item:
			var item = Global.get_item_data(hold_socket.item_id)
			if item.can_be_processed and target.has_item == false and not item.id not in target.required_ingredients:
				target.add_item(item.id)
				hold_socket.drop_item()
			else:
				print("Wrong Ingredient or food is already cooked.")
		elif not hold_socket.has_item:
			if target.has_item:
				print("This was called.") 
				hold_socket.grab_item(target.on_interact())
				target.remove_item()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= 9.8 * delta
