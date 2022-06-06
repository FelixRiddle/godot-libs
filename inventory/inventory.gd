# Inventory interface for item management
# This is an interface for an inventory system
# like minecraft or terraria, with the exception that it
# uses a dictionary to store items


# The name of this class
class_name Inventory

# Load class/es
var DictionaryUtils = preload(
		"res://godot-libs/libs/utils/dictionary_utils.gd")
var Item = preload("res://godot-libs/inventory/items/item.gd")
var ObjectUtils = preload("res://godot-libs/libs/utils/object_utils.gd")

# Signals
# The new inv is a reference to the actual inventory, remember that
signal inventory_changed(old_inv, new_inv)
signal item_removed(item)
signal item_added(item)
signal slots_changed(old_slots, new_slots)

# Properties
export(bool) var debug:bool = false setget set_debug, get_debug
var items = {} setget set_items, get_items
export(int) var size:int = 10 setget set_size, get_size

# Constructor
func _init(_options = {}):
	if(_options.has("debug") && typeof(_options["debug"]) == TYPE_BOOL && \
			_options["debug"]):
		self.debug = _options.debug
		print("Inventory(class) -> _init:")
	
	# If it's already connected, it would throw an error if we try to connect
	# it again
	if(!is_connected("item_added", self, "on_Inventory_item_added")):
		var connected = connect("item_added", self, \
			"on_Inventory_item_added")

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


# Try to place an item on another item
# TODO: Surely this won't work pretty well, so it needs some fixing
# [] 1. It will duplicate items if the inventories are different
func try_place(item, prev_item):
	if(item && prev_item):
		items[item.get_uuid()] = prev_item
		items[prev_item.get_uuid()] = item
		return true
	else:
		return false


# Search for available space and add items
# If there isn't enough space, it will return the amount remaining
# items_arr: An array of the item in inventory
# amount: Amount of items to add 
func _search_and_add(items_arr, amount):
	if(debug):
		print("Inventory.gd -> _search_and_add(items_arr, amount):")
	
	for i in range(items_arr.size()):
		var curr_item = items_arr[i]
		
		# The argument here is to make a "deep" copy of the dictionary
		var old_inventory = self.items.duplicate(true)
		
		var prev_amount = amount
		amount = curr_item.add(amount)
		
		# Previous amount is different than the current one
		if(prev_amount != amount):
			emit_signal("inventory_changed", old_inventory, self.items)
		
		if(amount <= 0):
			return amount
		# Keep looping to search for more space
	
	# At this point, there is not enough space to fill the items in
	return amount


# Add item by its id
# Returns a dict with with a state string
# WRONG_DATA: Wrong data given
# ITEM_ADDED: The item was added onto a slot that wasn't full
# INVENTORY_FULL: The inventory is full
# ITEM_INSERTED: The item was inserted into a new slot
func add_item_by_dictionary(item_data:Dictionary={
			"_": {
					"default_dictionary": true,
				},
			"info": { }
			}) -> Dictionary:
	if(debug):
		print("Inventory.gd -> add_item_by_dictionary(data:Dictionary):")
	
	var amount
	var id
	var info
	
	if(item_data.has("_") && item_data.has("default_dictionary") &&
			item_data["default_dictionary"]):
		# Get outta here
		return { "state": "WRONG_DATA" }
	elif(item_data.has("info")):
		var required_data:Dictionary = {
			"item_id": 1,
			"item_amount": 1,
		}
		info = item_data["info"]
		
		var validated = DictionaryUtils.validate_options(
			{ "info": info },
			required_data)
		
		if(validated):
			id = info["item_id"]
			amount = info["item_amount"]
		else:
			if(self.debug):
				print("Inventory(Script) -> add_item_by_id():")
				print("At least id and amount are required.")
				print("Data given: ", item_data)
			
			# Get outta here
			return { "state": "WRONG_DATA" }
	else:
		# Get outta here
		return { "state": "WRONG_DATA" }
	
	# Check if the item already exists and if it has space available
	var items_found = get_items_by_id(id)
	if(self.debug):
		print("Items in inventory with the same id: ", items_found)
	
	# If the item already exists
	if items_found:
		var remaining = _search_and_add(items_found, amount)
		
		if(remaining >= 1):
			info["item_amount"] = remaining
			if(self.debug):
				print("Remaining: ", remaining)
				print("Not enough space to add items, " + \
						"trying to create a new slot")
		else:
			if(self.debug):
				print("Added items")
			return { "state": "ITEM_ADDED" }
	
	# Check if the inventory is full
	if is_full():
		return { "state": "INVENTORY_FULL", "data": info }
	
	# Create item
	var new_item = Item.new()
	
	# We need to set this first, so that when we set the amount for the first
	# time it won't break
	new_item["item_capacity"] = info["item_capacity"] \
			if(info.has("item_capacity")) \
			else new_item["item_capacity"]
	ObjectUtils.set_info_unsafe(new_item, info)
	new_item.set_slot(get_first_empty_slot())
	
	_insert_item(new_item)
	return { "state": "ITEM_INSERTED" }
# Aliases
func add_item_by_dict(dict):
	return add_item_by_dictionary(dict)


# Creates an array of zeros
static func create_zero_array(length):
	var temp = []
	for _i in range(length):
		temp.append(0)
	return temp


# Get an array of the empty slots indexes
func get_empty_slots_array():
	if(debug):
		print("Inventory.gd -> get_empty_slots_array():")
	
	var result_array = []
	if(!self.items):
		for i in range(0, self.size):
			result_array.push_back(i)
		return result_array
	else:
		var occupied_slots = get_used_slots_array()
		
		for i in range(0, self.size):
			var isnt_occupied = true
			
			# Check if it isn't occupied
			for j in occupied_slots:
				if i == j:
					isnt_occupied = false
			
			# If it isn't occupied add at the end of the list
			if(isnt_occupied):
				result_array.push_back(i)
		return result_array
# Aliases
func get_slots_available():
	return get_empty_slots_array()
func get_empty_slots():
	return get_empty_slots_array()


# Get the first available slot, returns null if there are no slots available
func get_first_empty_slot():
	if(debug):
		print("Inventory.gd -> get_first_empty_slot():")
	var empty_slots = get_empty_slots()
	if(empty_slots != null):
		return empty_slots[0]
	else:
		return 0


# Get every item that has the provided id
func get_items_by_id(value):
	if debug:
		print("Inventory.gd -> get_items_by_id(value):")
		if(typeof(value) == TYPE_NIL):
			print("Warning: Null is " +
				"defaulted to create a random uuid.")
	
	if(!self.items):
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
	
	# Check if the array is empty
	if temp_arr.empty():
		return null
	else:
		return temp_arr


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
func get_items_by_name(value:String):
	var temp_arr = []
	for i in items.keys():
		#print("Current item: %s" % i)
		if(items[i].get_name() == value):
			temp_arr.push_back(items[i])
	
	# Check if the array is empty
	if temp_arr.empty():
		return null
	else:
		return temp_arr


# Get item by uuid, pretty useless, but just in case
func get_item_by_uuid(value):
	return items[value]


# Get item in a slot
func get_item_in_slot(value:int):
	if(self.debug):
		print("Inventory.gd -> get_item_in_slot(value):")
	
	for i in items.keys():
		var item = items[i]
		
		if(item.has_method("get_slot") && item.get_slot() == value):
			return item
	
	return null
# Aliases
func find_by_slot(value:int):
	return get_item_in_slot(value)
func find_item_in_slot(value:int):
	return get_item_in_slot(value)


# Default to get_used_slots_array, DON't CHANGE
func get_used_slots():
	return get_used_slots_array()


# Get used slots array
func get_used_slots_array():
	if(self.debug):
		print("Inventory.gd -> get_used_slots_array():")
	
	var result = []
	if(!self.items):
		return result
	
	# Iterate through the keys of the dictionary
	for i in self.items.keys():
		# Set the current item in a temporal variable
		var curr_item = self.items[i]
		
		# Push at the end
		result.push_back(curr_item.get_slot())
	return result


# Check if the inventory is full
func is_full():
	var items_amount = self.items.keys().size()
	if(debug):
		print("Inventory.gd -> is_full():")
	
	if(items_amount >= self.size):
		return true
	
	return false


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
		print("Inventory.gd -> print_items_name_array():")
	
	var zero_array = create_zero_array(size)
	
	for key in self.items.keys():
		var item = items[key]
		
		if(typeof(item) == TYPE_OBJECT && item.has_method("get_slot")) && \
				item.has_method("get_name"):
			zero_array[item.get_slot()] = item.get_name()
	
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
	if(items && items.has(value)):
		var item_erased = items[value]
		
		# The argument here is to make a "deep" copy of the dictionary
		var old_inventory = items.duplicate(true)
		
		# Dict function to delete a key/value pair
		items.erase(value)
		
		emit_signal("item_removed", item_erased)
		emit_signal("inventory_changed", old_inventory, self.items)
		emit_signal("slots_changed", old_inventory, self.items)
		
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
			var old_inventory = items.duplicate(true)
			emit_signal("inventory_changed", old_inventory, self.items)
			emit_signal("slots_changed", old_inventory, self.items)
			
			return remove_item_by_uuid(i)


# Insert an item to the items dictionary(the actual inventory)
# item: An Item class instance
func _insert_item(item):
	if(debug):
		print("Inventory.gd -> _insert_item(item):")
	
	# The argument here is to make a "deep" copy of the dictionary
	var old_inventory = items.duplicate(true)
	
	# Insert the item in the items dictionary
	self.items[item["uuid"]] = item
	
	emit_signal("item_added", item)
	emit_signal("inventory_changed", old_inventory, self.items)
	emit_signal("slots_changed", old_inventory, items)
	return item


### Size
func set_size(value:int) -> void:
	size = value
func get_size() -> int:
	return size
func set_length(value) -> void:
	set_size(value)


### Signals ###
# item: Instance of Item class
func on_Inventory_item_added(item):
	if(debug):
		print("Inventory.gd -> on_Inventory_item_added:")
		print("Received item in signal: ", item)
	
	# Check if the item exists and if it has the methods needed
	if(item && item.has_overflow()):
		if(self.debug):
			print("Adding overflow")
		
		# Overflow management
		# First try to add in the inventory
		var item_dict = {}
		
		# First we drop the overflow and then we get the item dictionary, or
		# else, we would create a new item with overflow, and this would loop
		# forever
		var item_overflow = item.drop_overflow()
		# We also need to duplicate the item image, in case it changes
		var item_image = item["item_image"].duplicate()
		item_dict = item.get_as_dict()
		
		# Set the new item amount to the overflow of the previous item
		item_dict["item_amount"] = item_overflow
		item_dict["item_image"] = item_image
		if(self.debug):
			print("Item dict: ", item_dict)
			print("Item overflow: ", item_dict["item_amount"])
		
		# Add item checks for the amount and id keys in the dictionary
		var state = add_item_by_dict({ "info": item_dict })
		if(self.debug):
			print("State of add overflow operation: ", state["state"])
