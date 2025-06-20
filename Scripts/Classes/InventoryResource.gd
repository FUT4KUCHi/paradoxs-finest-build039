class_name InventoryResource extends Resource

@export var items: Array[ItemResource] = []

func add_item(item: ItemResource) -> void:
	items.append(item)

func remove_item(item: ItemResource) -> void:
	items.erase(item)

func get_items() -> Array[ItemResource]:
	return items
