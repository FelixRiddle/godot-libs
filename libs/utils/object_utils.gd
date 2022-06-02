class_name ObjectUtils

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
