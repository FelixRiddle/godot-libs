class_name ArrayUtils

# Change the size of an array, returns a dictionary
# which in case of shrinking, contains the values of the deleted items
# The third argument is the object to populate the array with
static func change_length(arr:Array, new_size:int, element = 0) -> Dictionary:
	var dict = {
		"deleted_items": [],
		"new_array": [],
		"old_array": arr.duplicate(),
	}
	
	if(new_size < arr.size()):
		dict["deleted_items"] = get_last_items(arr, arr.size() - new_size)
		dict["new_array"] = shrink_array(arr, arr.size() - new_size)
	else:
		dict["new_array"] = increase_length(arr, new_size, element)
	return dict


static func change_size(arr:Array, new_size:int, element = 0) -> Dictionary:
	return change_length(arr, new_size, element)


# Counting Sort
# It assumes that the input is an array of integers
static func counting_sort(input:Array) -> Array:
	# k is the maximum value of the non-negative key values
	var k = get_max_number_in_array(input)
	var count = create_zero_array(k + 1)
	var output = create_zero_array(input.size())
	
	for i in range(input.size()):
		count[input[i]] += 1
	
	for i in range(1, k + 1):
		count[i] += count[i - 1]
	
	for i in range(input.size() - 1, - 1, - 1):
		var j = input[i]
		count[j] -= 1
		output[count[j]] = input[i]
	
	return output


# Creates an array of zeros
static func create_zero_array(length:int) -> Array:
	var temp = []
	for _i in range(length):
		temp.append(0)
	return temp


# Creates an array and fills it with the type provided
static func create_array_with(type, length:int) -> Array:
	var temp = []
	for _i in range(length):
		temp.append(type)
	return temp


# Get an array of the last items
static func get_last_items(arr:Array, length:int) -> Array:
	var new_arr = []
	if(arr.size() - 1 < 0):
		return arr
	for i in range(length):
		new_arr.push_back(arr[(arr.size() - 1) - i])
	return new_arr


# Get the max number in an array
static func get_max_number_in_array(arr:Array) -> int:
	var curr = arr[0]
	for i in range(arr.size()):
		curr = max(curr, arr[i])
	return curr


# Increase the size/length of the array
# The third argument is the object to populate the array with
static func increase_length(arr:Array, length:int, element = 0) -> Array:
	# The argument that takes Array.duplicate(bool) is for
	# doing a deep duplication where there will be no references
	var temp_arr:Array = arr.duplicate(true)
	for _i in range(length):
		temp_arr.append(element)
	
	return temp_arr


# Alias for increase_length
static func increase_size(arr:Array, length:int, element = 0) -> Array:
	return increase_length(arr, length, element)


# Reverse an array
static func reverse_array(arr:Array) -> Array:
	var new_arr = []
	for i in range(arr.size()):
		new_arr.push_back(arr[(arr.size() - 1) - i])
	return new_arr


# Shrink array
# The values are lost
# Returns a copy of the array
static func shrink_array(arr:Array, length:int) -> Array:
	var new_array = arr.duplicate(true)
	for _i in range(length):
		new_array.pop_back()
	
	return new_array


# The same change_length, except that this one tries to detect if the element
# is a path or a class
static func smart_change_length(arr:Array, \
			new_size:int, element = 0, _options = {}) -> Dictionary:
	var dict = {
		"deleted_items": [],
		"new_array": [],
		"old_array": arr.duplicate(),
	}
	
	if(new_size < arr.size()):
		dict["deleted_items"] = get_last_items(arr, arr.size() - new_size)
		dict["new_array"] = shrink_array(arr, arr.size() - new_size)
	else:
		dict["new_array"] = smart_increase_length(\
				arr, new_size - arr.size(), element, _options)
	return dict


static func smart_change_size(arr:Array, new_size:int, \
			element = 0, _options = {}) -> Dictionary:
	return smart_change_length(arr, new_size, element, _options)


# Create an array, but smart xD
static func smart_create_array_with(element, \
			length:int, _options = {}) -> Array:
	var temp_arr = []
	var Utils = preload("res://godot-libs/libs/utils/utils.gd")
	
	var type:String = Utils.get_resource_type(element)
	var el = Utils.load_resource(element)
	
	for _i in range(length):
		# Depending on the type there will be different methods
		# for instancing it
		if(type == "scene"):
			temp_arr.append(el.instance())
		elif(type == "script"):
			# Check if there were arguments provided
			if(_options.has("arg")):
				temp_arr.append(el.new(_options["arg"]))
			else:
				temp_arr.append(el.new())
		else:
			temp_arr.append(el)
	return temp_arr


# Increase the size/length of the array
# The third argument is the object to populate the array with
# _options can have:
# args: For instantiating classes
static func smart_increase_length(arr:Array, \
			length:int, element = 0, _options = {}) -> Array:
	# The argument that takes Array.duplicate(bool) is for
	# doing a deep duplication where there will be no references
	var temp_arr:Array = arr.duplicate(true)
	
	# Create a new array with the elements and append it to temp_arr
	var append_items = smart_create_array_with(\
			element, length, _options)
	temp_arr.append_array(append_items)
	
	return temp_arr
