extends Control

signal cells_changed(old_arr, new_arr)
signal overflowed(overflow)
signal size_changed(old_size, new_size)

var ArrayUtils = preload("res://godot-libs/libs/utils/array_utils.gd")
var Cell:PackedScene = preload("res://godot-libs/inventory_ui" + \
		"/cell/cell.tscn")
var Hotbar:PackedScene = preload("res://godot-libs/inventory_ui" + \
		"/hotbar/hotbar.tscn")
var InventoryContainer:PackedScene = preload("res://godot-libs/inventory_ui" + \
		"/inventory/inventory.tscn")

# uwu
# The length will likely be overrided
export(bool) var debug:bool = false setget set_debug, get_debug
export(int) var length:int = 1 setget set_length, get_length

# Do not edit in editor, these are exported to be accesed
# from another script
export(Array) var cells:Array = [] setget set_cells, get_cells
export(PackedScene) var hotbar = Hotbar.instance()
export(PackedScene) var inventory = InventoryContainer.instance()
export(Array) var overflow:Array = [] setget set_overflow, get_overflow

func _init():
	if(debug):
		print("InventoryManager -> _init:")
	
	# Instantiate the cells
	self.cells = ArrayUtils.create_array_with(Cell.instance(), \
			self.length)


func set_info(options:Dictionary) -> void:
	if(options.has("debug") \
			&& typeof(options["debug"]) == TYPE_BOOL):
		self.debug = options["debug"]
	if(debug):
		print("InventoryManager -> _init:")
	
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
	var result:Dictionary = ArrayUtils.change_size(cells, value, \
			Cell.instance())
	
	if(result.has("deleted_items")):
		self.overflow = result["deleted_items"]
		emit_signal("overflowed", self.overflow)
	
	if(result.has("new_array")):
		var old_cells = self.cells
		self.cells = result["new_array"]
		emit_signal("cells_changed", old_cells, self.cells)
	
	if(debug):
		print("Result: ", result)


func get_length() -> int:
	return length


# setget overflow
func set_overflow(value) -> void:
	overflow = value


func get_overflow() -> Array:
	return overflow
