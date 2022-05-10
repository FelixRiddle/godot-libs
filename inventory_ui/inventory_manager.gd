extends Control

# Scenes
export var Cell:PackedScene = preload("res://godot-libs/inventory_ui" + \
		"/cell/cell.tscn")
export var Hotbar:PackedScene = preload("res://godot-libs/inventory_ui" + \
		"/hotbar/hotbar.tscn")
export var Inventory:PackedScene = preload("res://godot-libs/inventory_ui" + \
		"/inventory/inventory.tscn")

var ArrayUtils = preload("res://godot-libs/libs/utils/array_utils.gd")
var cells:Array = [] setget set_cells, get_cells
var length:int = 1 setget set_length, get_length


func _init(options) -> void:
	if(options.has("length") && typeof(options["length"]) == TYPE_INT):
		self.length = options["length"]
	
	# Instantiate the cells
	self.cells = ArrayUtils.create_zero_array(self.length)


# setget cells
func set_cells(value) -> void:
	if(typeof(value) != TYPE_ARRAY):
		return
	cells = value


func get_cells() -> Array:
	return cells


# setget length
func set_length(value) -> void:
	if(typeof(value) != TYPE_INT):
		return
	length = value
	
	# TODO: Shrink or increase cells
	# ...


func get_length() -> int:
	return length
