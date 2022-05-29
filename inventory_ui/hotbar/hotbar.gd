extends Control

var ObjectUtils = preload("res://godot-libs/libs/utils/object_utils.gd")
var cells_manager = preload("res://godot-libs/inventory_ui/" + \
		"cells_manager/cells_manager.gd") setget , get_cells_manager

onready var grid_container = $BackgroundColor/GridContainer

var debug:bool = false setget set_debug, get_debug
var debug_first_half:String = "Hotbar(ui) -> "
var length = 0 setget set_length, get_length
var vertical = false setget set_vertical, get_vertical

func _ready() -> void:
	# The cells manager will be in charge of creating and
	# rearranging the cells
	var info:Dictionary = {
			"debug": self.debug,
			"length": self.length,
			"grid_ref": grid_container,
		}
	cells_manager = cells_manager.new({
		"info": info,
	})
	if(self.debug):
		print("Info: ", info)


func get_cells_manager():
	return cells_manager


func set_debug(value:bool) -> void:
	debug = value
	
	# Also set debug for the inventory class
	var val = cells_manager.get("debug")
	if(val != null):
		cells_manager.debug = self.debug
func get_debug() -> bool:
	return debug


func get_inventory():
	return self.cells_manager.inventory


func set_length(value:int) -> void:
	if(self.debug):
		print(debug_first_half + "set_length(value):")
		print("Value: ", 9)
	
	length = value
	
	# Update cells_manager
	ObjectUtils.set_info(cells_manager, {
		"debug": self.debug,
		"length": value,
	})
	
	# Also update the columns of the hotbar
	if(!self.vertical && grid_container):
		grid_container.columns = value
	elif(grid_container):
		grid_container.columns = 1
func get_length() -> int:
	return length


func set_vertical(value:bool) -> void:
	vertical = value
func get_vertical() -> bool:
	return vertical
