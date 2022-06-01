class_name ObjectUtils

# set info
static func set_info(object, options={"_": { "empty": true }}):
	if(!(object is Object) || object == null):
		return
	if(options.has("_")):
		var default_dict = options["_"]
		if(default_dict.has("empty") && \
				typeof(default_dict["empty"] == TYPE_BOOL) && \
				default_dict["empty"]):
			return
	
	for prop in options.keys():
		
		# Check if the key exists, and if the types are the same
		if(object.get(prop) != null && \
				typeof(object[prop]) == typeof(options[prop])):
			object[prop] = options[prop]
	
	return object
