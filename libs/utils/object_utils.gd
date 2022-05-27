class_name ObjectUtils

# set info
static func set_info(object, options={}) -> bool:
	for prop in options.keys():
		# Check if the key exists, and if the types are the same
		if(object.get(prop) != null && typeof(object[prop]) == typeof(options[prop])):
			object[prop] = options[prop]
	
	return true
