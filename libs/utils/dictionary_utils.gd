class_name DictionaryUtils

# dict1 is the provided dictionary
static func key_type_match(dict1, dict2, key):
	return dict1.has(key) && \
			typeof(dict1[key]) == typeof(dict2[key])


static func validate_options(options:Dictionary={
		"default_info": true,
		"info": {},
		}, required_data:Dictionary={
			"default_info": true,
		}):
	
	# Data to compare, if a key is not required, remove it from here
	if(required_data.has("default_info")):
		print("[-] Default information given")
		# Get outta here
		return
	
	if(options.has("default_info") && options["default_info"]):
		print("[-] Default information given")
		# Get outta here
		return
	var info
	if(options.has("info")):
		info = options["info"]
		
		if(typeof(info) == TYPE_DICTIONARY):
			for key in required_data.keys():
				var keys_match = key_type_match(info, required_data, key)
				if(!keys_match):
					print("[-] The key ", key, " wasn't given.")
					# Get outta here
					return
		else:
			print("[-] Info it's not a dictionary")
			# Get outta here
			return
	else:
		print("[-] Doesn't have info(data)")
		# Get outta here
		return
	
	print("[+] Correct information given")
	return true
