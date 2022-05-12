extends Node

# Get resource type, returns made up names
# scene, script, unknown
static func get_resource_type(res) -> String:
	var type:String
	
	# Check what it is
	if(typeof(res) == TYPE_STRING && \
			res.begins_with("res://")): # It's a resource
		
		# Check what type of resource it is
		# Note: Name extensions might change after the project was builded
		if(res.ends_with(".tscn")): # It's a scene
			type = "scene"
		if(res.ends_with(".gd")): # It's a script
			type = "script"
	else:
		type = "unknown"
	
	return type


# Try to load resource at a the provided path, if not posible
# returns the same value
static func load_resource(res):
	var el
	
	# Check what it is
	if(typeof(res) == TYPE_STRING && \
			res.begins_with("res://")): # It's a resource
		
		# Check what type of resource it is
		# Note: Name extensions might change after the project was builded
		if(res.ends_with(".tscn")): # It's a scene
			el = load(res)
		if(res.ends_with(".gd")): # It's a script
			el = load(res)
	else:
		el = res
	
	return el


# Print a property of every item in the array
func print_arr_item_props(arr:Array, prop_name:String) -> void:
	for i in range(arr.size()):
		var curr = arr[i]
		if(curr is Object && curr.get(prop_name)):
			print(prop_name, "(", i, "): ", curr[prop_name])
