extends Node

func get_all_children(node) -> Array:
	var nodes : Array = []
	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else: nodes.append(N)
	return nodes

func nearest_in_group (group : String, center : Vector3):
	var total = get_tree().get_nodes_in_group(group)
	if total.is_empty():
		return null
	
	var nearest = total[0]
	for member in total:
		var a = center.distance_to(nearest.global_transform.origin)
		var b = center.distance_to(member.global_transform.origin)
		if b<a:
			nearest = member
	return nearest

#this one's silly
func flat(vector : Vector3):
	var new_vector=Vector3(vector.x,0,vector.z)
	return new_vector
