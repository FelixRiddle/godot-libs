class_name ArrayUtils

# Counting Sort ###
static func counting_sort(input:Array) -> Array:
	if(typeof(input) != TYPE_ARRAY):
		return input
	
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
	if(typeof(length) != TYPE_INT):
		return []
	
	var temp = []
	for _i in range(length):
		temp.append(0)
	return temp


# TODO:
# Get an array of the last items
#static func get_last_items(arr:Array, length:int):

# Get the max number in an array
static func get_max_number_in_array(arr:Array) -> int:
	if(typeof(arr) != TYPE_ARRAY):
		return 0
	
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


# Shrink array
# The values are lost
# Returns a copy of the array
static func shrink_array(arr:Array, length:int) -> Array:
	var new_array = arr.duplicate(true)
	for i in range(length):
		new_array.pop_back()
	
	return new_array
