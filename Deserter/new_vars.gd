extends Node

func get_children_recursive(node : Node):
# warning-ignore:unassigned_variable
	var children : Array
	var grandchildren : Array
	for n in node.get_children():
		children.push_back(n)
		if n.get_child_count() > 0:
			grandchildren = get_children_recursive(n)
		for g in grandchildren:
			children.push_back(g)
	return children

func nearest_in_group (group : String, center : Vector3):
	var total = get_tree().get_nodes_in_group(group)
	if total.empty():
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
