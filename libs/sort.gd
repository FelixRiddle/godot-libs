class_name Sort

### Counting Sort ###
static func counting_sort(input):
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
static func create_zero_array(length):
	var temp = []
	for _i in range(length):
		temp.append(0)
	return temp

# Get the max number in an array
static func get_max_number_in_array(arr):
	var curr = arr[0]
	for i in range(arr.size()):
		curr = max(curr, arr[i])
	return curr
