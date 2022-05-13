extends CanvasLayer

var ArrayUtils = preload("res://godot-libs/libs/utils/array_utils.gd")
var Cell:PackedScene = preload("res://godot-libs/inventory_ui" + \
		"/cell/cell.tscn")
var Hotbar:PackedScene = preload("res://godot-libs/inventory_ui" + \
		"/hotbar/hotbar.tscn")
var InventoryContainer:PackedScene = preload(
		"res://godot-libs/inventory_ui/inventory/inventory.tscn")
var InventoryScript = preload("res://godot-libs/inventory/inventory.gd")

signal cells_changed(old_arr, new_arr)
signal overflowed(overflow)
signal size_changed(old_size, new_size)

# The length will likely be overrided
export(bool) var debug:bool = false setget set_debug, get_debug
export(int) var length:int = 0 setget set_length, get_length

var cells:Array = [] setget set_cells, get_cells
var hotbar = Hotbar.instance()
var inventory = InventoryScript.new() setget set_inventory, get_inventory
var inventory_container = InventoryContainer.instance()
var overflow:Array = [] setget set_overflow, get_overflow

func _init():
	if(debug):
		print("InventoryManager -> _init:")
	
	# Add to the scene tree
	add_child(hotbar)
	add_child(inventory_container)
	
	# Connect to the cells changed for instancing and destroying cells
	var connect_result = connect(
			"cells_changed", self, "_on_inventory_manager_cells_changed")
	
	if(debug):
		print("Connect result: ", connect_result)


func set_info(options:Dictionary) -> void:
	if(options.has("debug") \
			&& typeof(options["debug"]) == TYPE_BOOL):
		self.debug = options["debug"]
		inventory.debug = options["debug"]
	if(debug):
		print("InventoryManager -> set_info:")
	
	if(options.has("length") \
			&& typeof(options["length"]) == TYPE_INT):
		self.length = options["length"]
	
	
	if(debug):
		print("Cells: ", self.cells)


# setget cells
func set_cells(value) -> void:
	if(typeof(value) != TYPE_ARRAY):
		return
	cells = value
func get_cells() -> Array:
	return cells


# setget debug
func set_debug(value:bool) -> void:
	debug = value
func get_debug() -> bool:
	return debug


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
	var old_length:int = length
	length = value
	emit_signal("size_changed", old_length, length)
	
	if(debug):
		print("Resizing the array...")
	var result:Dictionary = ArrayUtils.smart_change_length(
			cells, value, Cell)
	
	if(result.has("deleted_items")):
		self.overflow = result["deleted_items"]
		emit_signal("overflowed", self.overflow)
	
	if(result.has("new_array")):
		var old_cells = self.cells
		self.cells = result["new_array"]
		emit_signal("cells_changed", old_cells, self.cells)
	
	if(debug):
		print("New array: ", self.cells)
func get_length() -> int:
	return length


func set_inv_size(value:int):
	return set_length(value)


# setget overflow
func set_overflow(value) -> void:
	overflow = value
func get_overflow() -> Array:
	return overflow


### Signals
func _on_inventory_manager_cells_changed(old_arr:Array = [], \
			new_arr:Array = []):
	
	# Remove old slots from the array
	
	# Add new slots to the array
	
	pass
