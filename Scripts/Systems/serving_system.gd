class_name ServingSystem 
extends Node

var tables : Array = []

func _ready():
	for child in %Kitchen.get_children():
		if child.has_method("show_indicator"):
			tables.append(child)

func request_available_table() -> Node3D:
	for table in tables:
		if table.has_method("is_taken") and not table.call("is_taken"):
			table.call("set_taken", true)
			return table
	return null

func release_tables(table: Node3D):
	if table and table.has_method("set_taken"):
		table.call("set_taken", false)
