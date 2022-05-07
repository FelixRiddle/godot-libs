class_name Item

# Scripts
var uuid_util = load("res://godot-libs/libs/uuid.gd")

# Signals
signal slot_changed
signal amount_changed(old_value, new_value)

export var class_id = 0 setget set_class_id, get_class_id
export var class_path = "" setget set_class_path, \
	get_class_path
export var debug = false setget set_debug, get_debug
export var scene_path = "" setget set_scene_path, \
	get_scene_path

# Because some values were predefined when extending Node
# we are going to use the prefix "item"
export var item_amount = 0 setget set_amount, get_amount
export var item_capacity = 1 setget set_capacity, get_capacity
export var item_description = "Sample text" \
	setget set_id, get_id
export var item_id = 0 setget set_id, get_id
export var item_name = "" setget set_name, get_name
# The slot must be a value between 1 and 10 inclusive
export var item_slot = 0 setget set_slot, get_slot
export var item_subtype = "" setget set_subtype, get_subtype
export var item_type = "" setget set_type, get_type

# Private fields
# A uuid is practically unique almost always
var uuid = uuid_util.v4() setget , get_uuid
var overflow = 0 setget set_overflow, get_overflow

### Functions/Methods ###
# Add items
func add(amount):
	if(typeof(amount) != TYPE_INT):
		return false
	
	item_amount += amount
	return true

# Create a new by a given dictionary of stats
static func create_item_by_dict(item):
	var temp_debug = item.get("debug") && item["debug"]
	if(temp_debug):
		print("Item.gd -> create_item_by_dict(item):")
	
	if(item):
		# If the path to the Item class doesn't exist
		if(!item.get("class_path")):
			if(temp_debug):
				print("The item provided doesn't have a class_path, item: ",
					item)
			return null
		
		# Even if the file isn't loaded, the script will continue executing
		var ItemClass = load(item["class_path"])
		
		# If the item class couldn't be loaded
		if(!ItemClass):
			if(temp_debug):
				print("Class not found, its path: ", item["class_path"])
			return null
		
		return ItemClass.new(item, null)

# Drop items
# item_dict: Result of the method call get_as_dict()
# amount: Amount of items to drop
func drop(item_dict, amount):
	if(typeof(amount) == TYPE_INT):
		# Check if there are enough items
		if(amount >= amount):
			item_dict["amount"] = amount
			return item_dict
		else:
			print("There are not enough items to drop")
	else:
		print("Item.gd -> drop(item_dict, amount): Amount it's not an " + \
			"integer.")
	
	return null

# Drop overflow
func drop_overflow():
	if(debug):
		print("Item.gd -> get_item_overflow(item_dict):")
	
	if(overflow > 0):
		# Insert overflow of this item into the new dictionary
		var _overflow = overflow
		overflow = 0
		return _overflow
	else:
		return null

# Find by id
static func find_by_id(id):
	var ItemsDatabase = \
		load("res://godot-libs/test/items_database/items_database.gd")
	
	# Check if the item exists in the database
	if typeof(id) == TYPE_INT:
		# Check if the item was already created
		var found_item = ItemsDatabase.get_item_by_id(id)
		
		# If the item doesn't exist
		if !found_item:
			return false
		else: # Item does exist
			return found_item
	
	# The "id" provided is NOT an integer,
	# which means it's not a predefined item
	return null

# Get as dict, overridable
func get_as_dict():
	return _get_item_stats_as_dict()

# Get item stats as dictionary
func _get_item_stats_as_dict():
	
	var result = {}
	
	if(get("class_id")):
		result["class_id"] = self.class_id
	if(get("class_path")):
		result["class_path"] = self.class_path
	if(get("item_amount")):
		result["amount"] = self.item_amount
	if(get("item_capacity")):
		result["capacity"] = self.item_capacity
	if(get("item_description")):
		result["description"] = self.item_description
	if(get("item_id")):
		result["item_id"] = self.item_id
	if(get("item_name")):
		result["name"] = self.item_name
	if(get("item_slot")):
		result["slot"] = self.item_slot
	if(get("item_subtype")):
		result["subtype"] = self.item_subtype
	if(get("item_type")):
		result["type"] = self.item_type
	if(get("scene_path")):
		result["scene"] = self.scene_path
	
	return result

# Find item
static func find(item):
	if(item.get("item_id")):
		return find_by_id(item["item_id"])
	else:
		return null

# Set info shorthand
# item_dict:
func set_info(item_dict):
	if(item_dict):
		if(item_dict.get("debug")):
			self.debug = item_dict["debug"]
		if(debug):
			print("Item.gd -> set_info(item):")
		
		if(item_dict.get("amount")):
			self.item_amount = item_dict["amount"]
		if(item_dict.get("capacity")):
			self.item_capacity = item_dict["capacity"]
		if(item_dict.get("class_id")):
			self.class_id = item_dict["class_id"]
		if(item_dict.get("class_path")):
			self.class_path = item_dict["class_path"]
		if(item_dict.get("description")):
			self.item_description = item_dict["description"]
		if(item_dict.get("name")):
			self.item_name = item_dict["name"]
		if(item_dict.get("scene_path")):
			self.scene_path = item_dict["scene_path"]
		if(item_dict.get("slot")):
			self.item_slot = item_dict["slot"]
		if(item_dict.get("subtype")):
			self.item_subtype = item_dict["subtype"]
		if(item_dict.get("type")):
			self.item_type = item_dict["type"]
		
		# If the value provided is null, default to create a uuid
		if(item_dict.get("item_id")):
			self.item_id = item_dict["item_id"]
		else:
			if(debug):
				print("Setting id to uuid")
			self.item_id = uuid_util.v4()
		
		return item_dict
	
	return null

### Amount
func set_amount(value):
	if(debug):
		print("Item.gd -> set_amount(value):")
		print("Amount to add: ", value)
	var old_amount = item_amount
	
	# There is space to store the items
	if(item_capacity >= item_amount + value):
		item_amount = value
	else: # There is not enough space
		var space_available = get_space_available()
		
		# We know because of the first check that value is bigger than
		# the space available
		var remaining_items = value - space_available
		
		# NOTE: This would calling this same function recursively
		#self.item_amount = item_capacity
		# Fill it up
		item_amount = item_capacity
		
		# Set the overflow to the remaining items, but we don't know for sure
		# if item_overflow is empty, so we add items to it
		overflow += remaining_items
	
	emit_signal("amount_changed", old_amount, item_amount)
func get_amount():
	return item_amount

# Get space available
func get_space_available():
	return item_capacity - item_amount

### Capacity
func set_capacity(value):
	item_capacity = value
func get_capacity():
	return item_capacity

# Check if the item has space
func has_space():
	if item_amount < item_capacity:
		return true
	else:
		return false

### Class id
func set_class_id(value):
	class_id = value
func get_class_id():
	return class_id

### Class path
func set_class_path(value):
	class_path = value
func get_class_path():
	return class_path

### Debug
func set_debug(value):
	debug = value
func get_debug():
	return debug

### Item description
func set_description(value):
	item_description = value
func get_description():
	return item_description

### ID
func set_id(value):
	item_id = value
func get_id():
	return item_id

### Item name
func set_name(value):
	item_name = value
func get_name():
	return item_name

### Overflow
func set_overflow(value):
	overflow = value
func get_overflow():
	return overflow

### Scene
func set_scene_path(value):
	scene_path = value
func get_scene_path():
	return scene_path

### Item slot
func set_slot(value):
	# Check if the provided value is an integer
	if typeof(value) == TYPE_INT:
		item_slot = value
		
		emit_signal("slot_changed")
	else:
		print("Item class -> set_slot(value): Expected type int, provided: %s"
			% typeof(value))
func get_slot():
	return item_slot

### Subtype
func set_subtype(value):
	item_subtype = value
func get_subtype():
	return item_subtype

### Item type
func set_type(value):
	item_type = value
func get_type():
	return item_type

### UUID
func get_uuid():
	return uuid
