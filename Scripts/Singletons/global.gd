class_name GlobalRegistry extends Node

var debug
var player
var player_inventory: InventoryResource = InventoryResource.new()
var player_cash: int

# Restaurent Variables
var shop_open: bool = false


var item_registry: Dictionary = {}
var dishes_registry: Dictionary = {}
var customer_registry: Dictionary = {}
var ingredient_registry: Dictionary = {}

func _register_items():
	item_registry["soup"] = load("res://Custom Resources/Food/Soup.tres")
	item_registry["meat"] = load("res://Custom Resources/Ingredients/Meat.tres")
	item_registry["bowl"] = load("res://Custom Resources/Ingredients/Bowl.tres")
	item_registry["egg"] = load("res://Custom Resources/Ingredients/Egg.tres")
	item_registry["steak"] = load("res://Custom Resources/Food/Steak.tres")
	item_registry["sushi-egg"] = load("res://Custom Resources/Food/SushiEgg.tres")
	item_registry["fried_egg"] = load("res://Custom Resources/Food/FriedEgg.tres")
	item_registry["chow_mein"] = load("res://Custom Resources/Food/ChowMein.tres")
	item_registry["sauerkraut"] = load("res://Custom Resources/Food/Sauerkraut.tres")
	item_registry["sausage"] = load("res://Custom Resources/Ingredients/Sausage.tres")
	item_registry["rice-ball"] = load("res://Custom Resources/Ingredients/RiceBall.tres")
	item_registry["sandwich"] = load("res://Custom Resources/Food/Sandwich.tres")
	item_registry["bread"] = load("res://Custom Resources/Ingredients/Bread.tres")

func _register_customers():
	customer_registry["emily"] = load("res://Custom Resources/Customers/Emily.tres")
	customer_registry["austin"] = load("res://Custom Resources/Customers/Austin.tres")
	customer_registry["tammy"] = load("res://Custom Resources/Customers/Tammy.tres")
	customer_registry["sam"] = load("res://Custom Resources/Customers/Sam.tres")

func _register_ingredients():
	ingredient_registry["meat"] = load("res://Custom Resources/Ingredients/Meat.tres")
	ingredient_registry["bowl"] = load("res://Custom Resources/Ingredients/Bowl.tres")
	ingredient_registry["sausage"] = load("res://Custom Resources/Ingredients/Sausage.tres")
	ingredient_registry["egg"] = load("res://Custom Resources/Ingredients/Egg.tres")
	ingredient_registry["rice-ball"] = load("res://Custom Resources/Ingredients/RiceBall.tres")
	ingredient_registry["bread"] = load("res://Custom Resources/Ingredients/Bread.tres")

func _register_dishes():
	dishes_registry["soup"] = load("res://Custom Resources/Food/Soup.tres")
	dishes_registry["steak"] = load("res://Custom Resources/Food/Steak.tres")
	dishes_registry["sauerkraut"] = load("res://Custom Resources/Food/Sauerkraut.tres")
	dishes_registry["sushi-egg"] = load("res://Custom Resources/Food/SushiEgg.tres")
	dishes_registry["fried_egg"] = load("res://Custom Resources/Food/FriedEgg.tres")
	dishes_registry["chow_mein"] = load("res://Custom Resources/Food/ChowMein.tres")
	dishes_registry["sandwich"] = load("res://Custom Resources/Food/Sandwich.tres")

func get_item_data(id: String) -> ItemResource:
	return item_registry.get(id)

func get_dish_data(id: String) -> ItemResource:
	return dishes_registry.get(id)

func get_ingredient_data(id: String) -> ItemResource:
	return ingredient_registry.get(id)

func get_customer_data(id: String) -> CustomerResource:
	return customer_registry.get(id)
