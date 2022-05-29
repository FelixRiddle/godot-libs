extends Control

var cells_manager = preload("res://godot-libs/inventory_ui/" + \
		"cells_manager/cells_manager.gd") setget , get_cells_manager
var ObjectUtils = preload("res://godot-libs/libs/utils/object_utils.gd")
var UIUtils = preload("res://godot-libs/libs/utils/ui_utils.gd")

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


#func _physics_process(delta):
#	cells_manager.middle_mouse_manager()

func _input(event):
	cells_manager.middle_mouse_manager()


# If required, call after setting the size for the cells
func set_automatic_size():
	# TODO: Change the cells position based on the space,
	# and for that add the previous x position to the new cell plus
	# the space between cells
	if(self.debug):
		print(debug_first_half + "set_automatic_size():")
	
	var reliable_viewport = UIUtils.get_reliable_viewport()
	var cell_min_size = cells_manager.cells_min_size
	
	# Space between cells in pixels
	# Here, 0.01 is equal to 1%
	# Therefore, the result will be 1% of the screen width
	var space_between_cells = reliable_viewport.x \
			* 0.01
	# Width of all cells combined
	var combined_cells_width = cell_min_size * self.length
	# We multiply the space between cells by the amount of cells we have + 2
	# because there will also be a space at the start and at the end
	var full_space_width = (space_between_cells * (self.length + 2))
	# Full hotbar width
	var full_width = combined_cells_width + full_space_width
	# Get the remaining width, in the rare case that the full_width is larger
	# than the screen width, then it would break
	var remaining_width = reliable_viewport.x - full_width
	# The remaining width / 2 will be the space between the start of the screen
	# and the hotbar, it will also be the space from the end of the hotbar to
	# the end of the screen
	var space = remaining_width / 2
	
	
#	if(self.debug):
#		print("Cells min size: ", cell_min_size)
#		print("Space between cells: ", space_between_cells)
#		print("Combined cells width: ", combined_cells_width)
#		print("Full space width: ", full_space_width)
#		print("Full width: ", full_width)
#		print("Remaining width: ", remaining_width)
#		print("Space: ", space)
	
	# Set anchor top
	anchor_top = 0
	
	# Set anchor left
	var x_space = UIUtils.get_x_pixel_percentage(space)
	anchor_left = x_space
	# Set anchor right to 1 - x_space
	anchor_right = 1 - x_space
	
#	if(self.debug):
#		print("x_space: ", x_space)
#		print("1 - x_space: ", 1 - x_space)
	
	# Set anchor bottom
	# Top and bottom space
	var y_cell_space = space_between_cells * 2
	# Add the cell space and the cell width/height
	var full_height = y_cell_space + cell_min_size
	var remaining_height = reliable_viewport.y - full_height
	# Because the anchor_bottom starts at 1
	var y_space = 1 - UIUtils.get_y_pixel_percentage(remaining_height)
#	if(self.debug):
#		print("Full height: ", full_height)
#		print("Remaining height: ", remaining_height)
#		print("y_space: ", y_space)
	anchor_bottom = y_space
	
#	if(self.debug):
#		print("Result: ")
#		print("Anchor left: ", anchor_left)
#		print("Anchor top: ", anchor_top)
#		print("Anchor right: ", anchor_right)
#		print("Anchor bottom: ", anchor_bottom)


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
	elif(grid_container):
		grid_container.columns = 1
func get_length() -> int:
	return length


func set_vertical(value:bool) -> void:
	vertical = value
func get_vertical() -> bool:
	return vertical
