class_name RadarComponent extends Node3D

func find_nearby_target(group_name: String, radius: float) -> Node3D:
	var closest_node = null
	var shortest_distance = radius
	for node in get_tree().get_nodes_in_group(group_name):
		var distance = global_position.distance_to(node.global_position)
		if node == self:
			continue
		if distance < shortest_distance:
			shortest_distance = distance
			closest_node = node
	return closest_node
