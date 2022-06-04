class_name ObjectUtils

# set info
static func set_info_unsafe(object, data:Dictionary):
	for prop in data.keys():
		var evaluation = object.get(prop) != null
#		print(prop, " != null: ", evaluation)
		# Check if the key exists
		if(evaluation):
#			print(prop, " has been set to: ", data[prop])
#			print("Object[", prop, "]: ", object[prop])
			object[prop] = data[prop]
	
	return object


# set info
static func set_info(object, data={"_": { "empty": true }}):
	if(!(object is Object) || object == null):
		return
	if(data.has("_")):
		var default_dict = data["_"]
		if(default_dict.has("empty") && \
				typeof(default_dict["empty"] == TYPE_BOOL) && \
				default_dict["empty"]):
			return
	
	for prop in data.keys():
		
		# Check if the key exists, and if the types are the same
		if(object.get(prop) != null && \
				typeof(object[prop]) == typeof(data[prop])):
			object[prop] = data[prop]
	
	return object
