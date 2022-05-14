class_name CellsManager

var Cell:PackedScene = preload("res://godot-libs/inventory_ui/" + \
		"cells_manager/cell/cell.tscn")
var InventoryScript = preload("res://godot-libs/inventory/inventory.gd")

signal cells_changed(old_arr, new_arr)
# Every time overflow changes free the previous ones?
signal overflow_changed(overflow)
signal size_changed(old_size, new_size)

export(bool) var debug:bool = false setget set_debug, get_debug
# The length will likely be overrided
export(int) var length:int = 0 setget set_length, get_length

var cells:Array = [] setget set_cells, get_cells
var inventory = InventoryScript.new() setget set_inventory, get_inventory
var node_ref setget set_node_ref, get_node_ref
var overflow:Array setget set_overflow, get_overflow

# Constructor
# info is a dictionary containing values for this object properties
func _init(options:Dictionary = { "info": { } }):
	# Connect to other node
#    var timer = get_node("Timer")
#    timer.connect("timeout", self, "_on_Timer_timeout")
	
	# Connect inventory changed
	inventory.connect("inventory_changed", self, \
			"_on_inventory_inventory_changed")
	
	# Connect size changed
	inventory.connect("size_changed", self, "_on_inventory_size_changed")
	
	# Connect to the cells changed for instancing and destroying cells
	var _connect_result = connect(
			"cells_changed", self, "_on_inventory_manager_cells_changed")
	
	# Set info
	if(options.has("info") && typeof(options["info"]) == TYPE_DICTIONARY):
		set_info(options["info"])


# setget cells
func set_cells(value:Array) -> void:
	cells = value
func get_cells() -> Array:
	return cells


# setget debug
func set_debug(value:bool) -> void:
	debug = value
func get_debug() -> bool:
	return debug


# Shorthand to set data
func set_info(options:Dictionary) -> void:
	if(options.has("debug") \
			&& typeof(options["debug"]) == TYPE_BOOL):
		self.debug = options["debug"]
		inventory.debug = options["debug"]
	
	if(debug):
		print("InventoryManager -> set_info:")
		print("Information given: ", options)
	
	# Set length/size
	if((options.has("length") \
			&& typeof(options["length"]) == TYPE_INT)):
		self.length = options["length"]
	if((options.has("size") \
			&& typeof(options["size"]) == TYPE_INT)):
		self.length = options["size"]
	
	# Set node reference
	if(options.has("node_ref") && options["node_ref"] is Node):
		self.node_ref = options["node_ref"]


func set_inventory(value:Inventory) -> void:
	inventory = value
func get_inventory() -> Inventory:
	return inventory


# setget length
# When shrinking the array, it will store the deleted cells in
# the overflow variable
func set_length(value:int) -> void:
	if(debug):
		print("InventoryManager -> set_length:")
	
	# For later use, set updated to false
	for cell in self.cells:
		cell.updated = false
	
	var old_length:int = length
	length = value
	emit_signal("size_changed", old_length, length)
	
	if(debug):
		print("Resizing the array...")
	var result:Dictionary = ArrayUtils.smart_change_length(
			cells, value, Cell, { "debug": self.debug, })
	
	if(debug):
		print("Result: ", result)
	
	if(result.has("new_array")):
		var old_cells = self.cells.duplicate(true)
		self.cells = result["new_array"]
		
		if(node_ref):
			# Add cells to the scene tree
			for cell in self.cells:
				cell.updated = true
				node_ref.add_child(cell)
			
			if(debug):
				print("Added cells to the scene!")
		elif(debug):
			print("Reference doesn't exist!")
		
		emit_signal("cells_changed", old_cells, self.cells)
	
	# Remove previous overflow
	for i in range(cells.duplicate().size()):
		cells[i].queue_free()
	
	if(result.has("deleted_items")):
		self.overflow = result["deleted_items"]
		emit_signal("overflow_changed", self.overflow)
func get_length() -> int:
	return length


func set_node_ref(value) -> void:
	node_ref = value
func get_node_ref():
	return node_ref


func set_overflow(value:Array) -> void:
	overflow = value
func get_overflow() -> Array:
	return overflow


### Signals
func _on_inventory_manager_cells_changed(old_arr:Array = [], \
			new_arr:Array = []) -> void:
	# Remove old slots from the array
	
	# Add new cells to the array
	if(debug):
		print("New cells: ", cells)


# When there are items added or removed from inventory
func _on_inventory_inventory_changed(old_inv:Dictionary = {},
			new_inv_ref:Dictionary = {}) -> void:
	
	pass

# When the inventory length/size changes
func _on_inventory_size_changed(old_size:int, new_size:int) -> void:
	set_length(new_size)
