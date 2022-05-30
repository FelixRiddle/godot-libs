extends Control

var cells_manager = preload("res://godot-libs/inventory_ui/" + \
		"cells_manager/cells_manager.gd") setget , get_cells_manager
var ObjectUtils = preload("res://godot-libs/libs/utils/object_utils.gd")
var UIUtils = preload("res://godot-libs/libs/utils/ui_utils.gd")
var UIExtra = preload("res://godot-libs/libs/utils/ui_extra.gd")

export(bool) var auto_resize:bool = true

onready var grid_container = $BackgroundColor/GridContainer

var debug:bool = false setget set_debug, get_debug
var debug_first_half:String = "Hotbar(ui) -> " setget set_debug_first_half, \
		get_debug_first_half
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
		self.debug_first_half = "[" + self.name + "] Hotbar(ui) -> "
	
	if(auto_resize):
		auto_resize_hotbar()


func _input(event):
	cells_manager.middle_mouse_manager()


# If required, call after setting the size for the cells
func auto_resize_hotbar():
	# TODO: Change the cells position based on the space,
	# and for that add the previous x position to the new cell plus
	# the space between cells
	if(self.debug):
		print(debug_first_half + "set_automatic_size():")
	
	print("Debug: ", self.debug)
	UIExtra.set_hotbar_panel_anchors({
		"info": {
			"cells_min_size": cells_manager.cells_min_size,
			"debug": self.debug,
			"grid_container": self,
			"length": cells_manager.length,
		}
	})
	
	return


func set_horizontal_cells_position(cells:Array, step:float):
	var sum = step
	for cell in cells:
		cell.rect_position = Vector2(sum, step)
		sum += step


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


func set_debug_first_half(value:String) -> void:
	debug_first_half = value
func get_debug_first_half() -> String:
	return debug_first_half


func get_inventory():
	return self.cells_manager.inventory


func set_length(value:int) -> void:
	if(self.debug):
		print(debug_first_half + "set_length(value):")
		print("Value: ", value)
	
	length = value
	
	# Update cells_manager
	ObjectUtils.set_info(cells_manager, {
		"debug": self.debug,
		"length": value,
	})
	
	# Also update the columns of the hotbar
	if(!self.vertical && grid_container):
		grid_container.columns = value
		
		if(auto_resize):
			auto_resize_hotbar()
	elif(grid_container):
		grid_container.columns = 1
func get_length() -> int:
	return length


func set_vertical(value:bool) -> void:
	vertical = value
func get_vertical() -> bool:
	return vertical
