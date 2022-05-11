class_name ArrayUtils

# Change the size of an array, returns a dictionary
# which in case of shrinking, contains the values of the deleted items
static func change_length(arr:Array, new_size:int) -> Dictionary:
	var dict = {
		"deleted_items": [],
		"new_array": [],
		"old_array": arr.duplicate(),
	}
	
	if(new_size < arr.size()):
		dict["deleted_items"] = get_last_items(arr, new_size)
		dict["new_array"] = shrink_array(arr, new_size)
	else:
		dict["new_array"] = increase_length(arr, new_size)
	return dict


static func change_size(arr:Array, new_size:int) -> Dictionary:
	return change_length(arr, new_size)


# Counting Sort ###
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
static func increase_length(arr:Array, length:int) -> Array:
	# The argument that takes Array.duplicate(bool) is for
	# doing a deep duplication where there will be no references
	var temp_arr:Array = arr.duplicate(true)
	for _i in range(length):
		temp_arr.append(0)
	
	return temp_arr


# Alias for increase_length
static func increase_size(arr:Array, length:int) -> Array:
	return increase_length(arr, length)


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