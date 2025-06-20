class_name ItemResource extends Resource

@export var name: String
@export var id: String
@export var visual: Texture2D
@export var scene: PackedScene
@export var can_be_processed: bool
@export var processed_item_id: String
@export var processed_item_visual: Texture2D
@export var procesed_item_scene: PackedScene
@export var required_ingredients: Array[String]
@export var cost: int
@export_multiline var description: String
