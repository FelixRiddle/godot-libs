# The name of this class
class_name Inventory

# Load class/es
var Item = load("res://godot-libs/inventory/items/item.gd")

# Signals
signal inventory_changed
signal item_removed(item)
signal item_added(item)

# Properties
export(bool) var debug:bool = false setget set_debug, get_debug
var items = {} setget set_items, get_items
export(int) var size:int = 10 setget set_size, get_size

# Constructor
func _init(_options):
	if(_options.debug): self.debug = _options.debug
	
	if(debug): print("Constructor")
	# If it's already connected, it would throw an error if we try to connect
	# it again
	if(!is_connected("item_added", self, "on_Inventory_item_added")):
		var connected = connect("item_added", self, \
			"on_Inventory_item_added")
		print("Connect return:\n", connected)

### Functions/Methods ###
### Debug
# Set and get
func set_debug(value):
	debug = value
func get_debug():
	return debug

### Items
# Set and get
func set_items(value):
	items = value
	emit_signal("inventory_changed")
func get_items():
	return items.duplicate()

func add(item: Item, amount: int = 1):
	pass

# Add item by its id
# This functions adds an item by searching its id on the ItemsDatabase
# class, if it isn't found it defaults to create a new Item with that id and
# adds it to the inventory.
# id: The item id in the database or different id to create a new item
# amount: The amount to add to the items
# The return is unreliable, it will only return one copy of the inserted items
func add_item_by_id(id, amount):
	if(debug):
		print("Inventory.gd -> add_item_by_id(id, amount):")
	
	# Check if the item already exists and if it has space available
	var items_found = get_items_by_id(id)
	if(debug):
		print("Items in inventory with the same id: ", items_found)
	
	# If the item already exists
	var remaining
	if items_found:
		remaining = _search_and_add(items_found, amount)
		
		if typeof(remaining) == TYPE_BOOL:
			return true
	
	# Check if the inventory is full
	if is_full():
		if(debug): print("Inventory full")
		return null
	
	if(items_found):
		_add_remaining_items(remaining, items_found[0])
	
	var new_item = _create_item_by_id(id)
	if(new_item):
		if(typeof(remaining) == TYPE_INT && remaining >= 1):
			new_item.set_amount(remaining)
		else:
			new_item.set_amount(amount)
		new_item.set_slot(get_first_empty_slot())
	else:
		if(debug): print("Couldn't create the item")
		return null
	
	_insert_item(new_item)
	return new_item

# In case you want to insert from an item dictionary, for example, when an
# item overflows.
func add_item(item):
	if(!item.get("item_id") || !item.get("amount")): return null
	return add_item_by_id(item["item_id"], item["amount"])

# Creates an array of zeros
static func create_zero_array(length):
	var temp = []
	for _i in range(length):
		temp.append(0)
	return temp

# When dragging and dropping an item into another item
# TODO: Surely this won't work pretty well, so it needs some fixing
func drag_and_drop(item, prev_item):
	if(item && prev_item):
		items[item.get_uuid()] = prev_item
		items[prev_item.get_uuid()] = item
		return true
	else: return false

# Defaults to get_empty_slots_array(), DON'T CHANGE
func get_slots_available():
	return get_empty_slots_array()
func get_empty_slots():
	return get_empty_slots_array()

# Get an array of the empty slots indexes
func get_empty_slots_array():
	if(debug):
		print("Inventory.gd -> get_empty_slots_array():")
	
	var result_array = []
	if(!self.items):
		for i in range(1, self.size + 1):
			result_array.push_back(i)
		return result_array
	else:
		var occupied_slots = get_used_slots_array()
		
		for i in range(1, self.size + 1):
			var isnt_occupied = true
			
			# Check if it isn't occupied
			for j in occupied_slots:
				if i == j:
					isnt_occupied = false
			
			# If it isn't occupied add at the end of the list
			if(isnt_occupied):
				result_array.push_back(i)
		return result_array

# Get the first available slot, returns null if there are no slots available
func get_first_empty_slot():
	if(debug):
		print("Inventory.gd -> get_first_empty_slot():")
	var empty_slots = get_empty_slots()
	if(empty_slots):
		return empty_slots[0]
	else: return null

# Get every item that has the provided id
func get_items_by_id(value):
	if debug:
		print("Inventory.gd -> get_items_by_id(value):")
		if(typeof(value) == TYPE_NIL):
			print("Warning: Null is " +
				"defaulted to create a random uuid.")
	
	if(!self.items):
		print("Warning: Items is null")
		return null
	
	var temp_arr = []
	# For every key in items, store it on i
	for i in self.items.keys():
		var curr_item = items[i]
		
		# If the id of the current item is the same as value
		if(curr_item && curr_item.has_method("get_id") && \
				curr_item.get_id() == value):
			# Push item at the end of the array
			temp_arr.push_back(curr_item)
			# Push item at the start
			#temp_arr.push_front(curr_item)
	if(debug && temp_arr): print("Temp arr: ", temp_arr)
	
	# Check if the array is empty
	if temp_arr.empty():
		return null
	else: return temp_arr

# Get item by name
# This will return the first item it finds
func get_item_by_name(value):
	# Check if its the correct type
	if typeof(value) != TYPE_STRING:
		print("Inventory.gd -> get_items_by_name(value): Value is not " +
			"a string, value: %s" % value)
		return
	
	for i in items.keys():
		#print("Current item: %s " % i)
		if(items[i].get_name() == value):
			return items[i]
	return null

# Get items by name
func get_items_by_name(value):
	# Check if its the correct type
	if typeof(value) != TYPE_STRING:
		print("Inventory.gd -> get_items_by_name(value): Value is not " +
			"a string, value: %s" % value)
		return
	
	var temp_arr = []
	for i in items.keys():
		#print("Current item: %s" % i)
		if(items[i].get_name() == value):
			temp_arr.push_back(items[i])
	
	# Check if the array is empty
	if temp_arr.empty():
		return null
	else: return temp_arr

# Get item by uuid, pretty useless, but just in case
func get_item_by_uuid(value):
	return items[value]

# Other names
func find_item_in_slot(value):
	return get_item_in_slot(value)
# Get item in a slot
func get_item_in_slot(value):
	if(debug):
		print("Inventory.gd -> get_item_in_slot(value):")
	
	if(typeof(value) != TYPE_INT):
		if(debug):
			print("Value is not an integer")
		return null
	
	for i in items.keys():
		var item = items[i]
		
		if(item.has_method("get_slot") && item.get_slot() == value):
			return item
	
	return null

# Default to get_used_slots_array, DON't CHANGE
func get_used_slots():
	return get_used_slots_array()

# Get used slots array
func get_used_slots_array():
	#if(debug):
	#	print("Inventory.gd -> get_used_slots_array():")
	
	var result = []
	if(!self.items):
		return result
	
	# Iterate through the keys of the dictionary
	for i in self.items.keys():
		# Set the current item in a temporal variable
		var curr_item = self.items[i]
		
		# Check if the method exists(because if it doesn't, it would throw
		# an error)
		if(curr_item.has_method("get_slot")):
			# Push at the end
			result.push_back(curr_item.get_slot())
	return result

# Check if the inventory is full
func is_full():
	print("Inventory.gd -> is_full():")
	# Get available slots
	var slots_available = get_slots_available()
	# If the slots_available array is empty, it's the same as null
	if(slots_available): return false
	else: return true

# Print items on the console
func print_items_as_dict():
	if(debug):
		print("Inventory.gd -> print_items_as_dict():")
	
	if(!items):
		if(debug): print("There are no items")
		return
	
	for i in items.keys():
		var curr_item = items[i]
		
		if(curr_item && curr_item.has_method("get_as_dict")):
			print(i, ": ", curr_item.get_as_dict())

# Print items name as an array
func print_items_name_array():
	if(debug):
		print("Inventory.gd -> print_items_name_as_an_array():")
	
	var zero_array = create_zero_array(size + 1)
	
	for i in self.items.keys():
		var item = items[i]
		
		if(typeof(item) == TYPE_OBJECT && item.has_method("get_slot")) && \
				item.has_method("get_name"):
			zero_array[item.get_slot()] = item.get_name()
	
	# Because items slots go from 1-10
	zero_array.pop_front()
	print(zero_array)
	return zero_array

# Print used slots
func print_used_slots():
	print(get_used_slots())

# Remove an item by id(the key)
func remove_item_by_uuid(value):
	if(debug):
		print("Inventory.gd -> remove_item_by_uuid(value):")
	
	# Check if the item exists
	if(items && items.get(value)):
		var item_erased = items[value]
		items.erase(value)
		
		emit_signal("item_removed", item_erased)
		emit_signal("inventory_changed")
		
		return item_erased

# Remove item by slot
func remove_item_by_slot(value):
	if(debug):
		print("Inventory.gd -> remove_item_by_slot(value):")
	
	if(typeof(value) != TYPE_INT || value > size):
		return
	
	for i in self.items.keys():
		var item = items[i]
		
		if(item.has_method("get_slot") && item.get_slot() == value):
			return remove_item_by_uuid(i)

# Note: I consider functions that start with a "_" private functions
# Add remaining items
func _add_remaining_items(remaining, sample_item):
	if(debug):
		print("Inventory.gd -> _add_remaining_items(remaining, sample_item):")
		print("Remaining items to add: ", remaining)
	
	# If there is no sample_item
	if(!sample_item):
		return null
	
	# Check if there are items remaining
	if typeof(remaining) == TYPE_INT && remaining >= 1 && \
			sample_item.has_method("get_as_dict") && \
			Item.has_method("create_item"):
		# Insert the item in a new slot
		var item_info = sample_item.get_as_dict()
		item_info["amount"] = remaining # Set the remaining as the amount
		var new_item = Item.create_item(item_info)
		
		# Insert the new item
		self.items[new_item["uuid"]] = new_item
		return new_item
	
	return null

# Create instance of Item with the item stats
func _create_item_by_id(id):
	var new_item = Item.new()
	
	if(debug):
		print("Inventory.gd -> _create_item_by_id(id):")
	if(!new_item.has_method("find_by_id") || \
			!new_item.has_method("create_item_by_dict")):
		if(debug): print("Warning: method find_by_id not found on Item class")
		return null
	
	# If the item is in the ItemDatabase(list of items)
	var item_found = new_item.find_by_id(id)
	
	if(item_found):
		# Add the amount
		if(debug): print("Item found: ", item_found)
		item_found["debug"] = self.debug
		
		new_item = new_item.create_item_by_dict(item_found)
		return new_item
	elif(debug):
		print("Item not found, item: ", item_found)
	
	return null

# Insert an item to the items dictionary(the actual inventory)
# item: An Item class instance
func _insert_item(item):
	if(debug):
		print("Inventory.gd -> _insert_item(item):")
	
	# If the item doesn't exist
	if(!item):
		if(debug): print("Warning: The item is null: ", item)
	elif(item.get("uuid")):
		# Insert the item in the items dictionary
		self.items[item["uuid"]] = item
		
		emit_signal("item_added", item)
		emit_signal("inventory_changed")
		return item
	elif(debug):
		print("Warning: The new item doesn't have an uuid?, item:")
		print(item)
	
	return null

# Search for available space and add items
# If there isn't enough space, it will return the amount remaining
# items_arr: An array of the item in inventory
# amount: Amount of items to add 
func _search_and_add(items_arr, amount):
	if(debug):
		print("Inventory.gd -> _search_and_add(items_arr, amount):")
	
	for i in range(items_arr.size()):
		var curr_item = items_arr[i]
		
		# Check if there is space available
		if curr_item.has_method("has_space") && curr_item.has_space() && \
				curr_item.has_method("get_space_available"):
			
			var space_available = curr_item.get_space_available()
			
			if amount <= space_available:
				# There is enough space
				# Add everthing to the item
				self.items[curr_item.uuid].add(amount)
				return true
			else:
				# There is space, but not enough
				# Remove some from the amount
				amount -= space_available
				# Add the remaining space
				self.items[curr_item.uuid].add(space_available)
				
				# Keep looping to search for more space
	
	# At this point, there is not enough space to fill the items in
	return amount

### Size
func set_size(value):
	size = value
func get_size():
	return size

### Signals ###
# new_item: Instance of Item class
func on_Inventory_item_added(item):
	if(debug):
		print("Inventory.gd -> on_Inventory_item_added:")
		print("Received item in signal: ", item)
	
	# Check if the item exists and if it has the methods needed
	if(item && item.has_method("drop_overflow") && \
			item.has_method("get_as_dict")):
		# Overflow management
		# First try to add in the inventory
		var item_dict = item.get_as_dict()
		item_dict["amount"] = item.drop_overflow()
		if(debug):
			print("Item overflow: ", item_dict["amount"])
		
		# Add item checks for the amount and id keys in the dictionary
		var result = add_item(item_dict)
		
		# If result is null, it means that it couldn't be added, in that case
		# the items should be removed or dropped to the ground
		if(result):
			if(debug):
				print("Overflow added")
