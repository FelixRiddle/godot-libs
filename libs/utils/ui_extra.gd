class_name UIExtra

# Get space between cells
static func space_between_cells():
	var reliable_viewport = UIUtils.get_reliable_viewport()
	
	# Variables
	# Space between cells in pixels
	# Here, 0.01 is equal to 1%
	# Therefore, the result will be 1% of the screen width
	var space_between_cells = reliable_viewport.x \
			* 0.01
	
	return space_between_cells


static func inventory_width(cells_size:float,
		length:int, debug:bool=false):
	var space_between_cells = space_between_cells()
	
	# Width of all cells combined
	var combined_cells_width = cells_size * length
	# We multiply the space between cells by the amount of cells we have + 2
	# because there will also be a space at the start and at the end
	var full_space_width = space_between_cells * (length + 1)
	# Full hotbar width
	var inventory_width = combined_cells_width + full_space_width
	
	if(debug):
		print("Cells min size: ", cells_size)
		print("Space between cells: ", space_between_cells)
		
		print("Combined cells width: ", combined_cells_width)
		print("Full space width: ", full_space_width)
		print("Inventory width: ", inventory_width)
	
	return inventory_width


static func inventory_height(cells_size:float,
		length, debug:bool=false):
	var space_between_cells = space_between_cells()
	
	# Cell height * rows
	var combined_cells_height = cells_size * length
	# Set anchor bottom
	# Top and bottom space
	var full_space_height = space_between_cells * (length + 1)
	# Add the cell space and the cell width/height
	var inventory_height = full_space_height + combined_cells_height
	
	if(debug):
		print("Cells min size: ", cells_size)
		print("Space between cells: ", space_between_cells)
		
		print("Combined cells height: ", combined_cells_height)
		print("Total space between cells: ", full_space_height)
		print("Inventory height: ", inventory_height)
	
	return inventory_height


# Get the remaining width:
# Which is the full width of the viewport - the width of the object_size
static func remaining_width(cells_size:float,
		length, debug:bool=false):
	var reliable_viewport = UIUtils.get_reliable_viewport()
	var inventory_width = inventory_width(cells_size, length)
	
	# Get the remaining width, in the rare case that the full_width is larger
	# than the screen width, then it would break
	var remaining_width = reliable_viewport.x - inventory_width
	
	if(debug):
		print("Window width: ", reliable_viewport.x)
		print("Inventory width: ", inventory_width)
		print("Remaining width: ", remaining_width)
	
	return remaining_width


# Get the remaining width:
# Which is the full width of the viewport - the width of the object_size
static func remaining_height(cells_size:float,
		length:int, debug:bool=false):
	var reliable_viewport = UIUtils.get_reliable_viewport()
	var inventory_height = inventory_height(cells_size, length)
	
	# Get the remaining width, in the rare case that the full_width is larger
	# than the screen width, then it would break
	var remaining_height = reliable_viewport.y - inventory_height
	
	if(debug):
		print("Remaining height: ", remaining_height)
	
	return remaining_height


# Set hotbar cells accordingly
static func set_cells_position(options:Dictionary):
	# Data required for this function to work properly
	var required_data = {
			"cells": [Node.new()],
			"cells_manager": TextureButton.new(),
			"debug": false,
			"length": 1,
		}
	var DictionaryUtils = load("res://godot-libs/libs/" + \
			"utils/dictionary_utils.gd")
	var valid_data = DictionaryUtils.validate_options(options, required_data)
	if(!valid_data):
		# Get outta here
		return
	
	# TODO: Change the cells position based on the space,
	# and for that add the previous x position to the new cell plus
	# the space between cells
	var info = options["info"]
	
	var cells = info["cells"]
	var cm = info["cells_manager"]
	var debug = info["debug"] if info.has("debug") else false
	var length = info["length"]
	
	if(debug):
		print("UIExtra -> set_cells_position(options:Dictionary):")
	
	# Space between cells in pixels
	# Here, 0.01 is equal to 1%
	# Therefore, the result will be 1% of the screen width
	var reliable_viewport = UIUtils.get_reliable_viewport()
	var space_between_cells = reliable_viewport.x \
			* 0.01
	var cells_min_size = cm.cells_min_size
	
	var position_x = space_between_cells
	var position_y = space_between_cells
	for i in range(length):
		var cell = cells[i]
		
		cell.rect_position = Vector2(position_x, position_y)
		position_x += cells_min_size + space_between_cells


# If required, call after setting the size for the cells
# Returns null if the information provided is wrong
static func set_hotbar_panel_anchors(options:Dictionary):
	# This data is necesary, for this function to work
	# other data, like debug, is optional
	var required_data = {
			"cells_min_size": 1.1,
			"grid_container": GridContainer.new(),
			"length": 1,
		}
	var DictionaryUtils = load("res://godot-libs/libs/" + \
			"utils/dictionary_utils.gd")
	var valid_data = DictionaryUtils.validate_options(options, required_data)
	if(!valid_data):
		# Get outta here
		return
	
	var info = options["info"]
	
	# Load some modules
	var UIUtils = load("res://godot-libs/libs/utils/ui_utils.gd")
	var ObjectUtils = load("res://godot-libs/libs/utils/object_utils.gd")
	
	# Variables
	# Anchors final value will be stored here
	var anchor_top = 0
	var anchor_right = 0
	var anchor_bottom = 0
	var anchor_left = 0
	
	var cell_min_size = info["cells_min_size"]
	var debug = info["debug"] if info.has("debug") else false
	var length = info["length"]
	var reliable_viewport = UIUtils.get_reliable_viewport()
	
	if(debug):
		print("UIExtra -> set_hotbar_panel_anchors(options:Dictionary):")
	
	var remaining_width = remaining_width(cell_min_size, length)
	# The remaining width / 2 will be the space between the start of the screen
	# and the hotbar, it will also be the space from the end of the hotbar to
	# the end of the screen
	var space = remaining_width / 2
	
	# Set anchor top
	anchor_top = 0
	
	# Set anchor left
	var x_space = UIUtils.get_x_pixel_percentage(space)
	anchor_left = x_space
	# Set anchor right to 1 - x_space
	anchor_right = 1 - x_space
	
	if(debug):
		print("x_space: ", x_space)
		print("1 - x_space: ", 1 - x_space)
	
	# hotbar_height - Windows height
	var remaining_height = remaining_height(cell_min_size, 1, debug)
	# Because the anchor_bottom starts at 1
	var y_space = 1 - UIUtils.get_y_pixel_percentage(remaining_height)
	if(debug):
		print("remaining_height / reliable_viewport.y: ",
				remaining_height / reliable_viewport.y)
		print("reliable_viewport.y / remaining_height: ",
				reliable_viewport.y / remaining_height)
		print("Remaining height: ", remaining_height)
		print("y_space: ", y_space)
	anchor_bottom = y_space
	
	if(debug):
		print("Result: ")
		print("Anchor left: ", anchor_left)
		print("Anchor top: ", anchor_top)
		print("Anchor right: ", anchor_right)
		print("Anchor bottom: ", anchor_bottom)
	
	var result = {
			# Clockwise order
			"anchor_top": anchor_top,
			"anchor_right": anchor_right,
			"anchor_bottom": anchor_bottom,
			"anchor_left": anchor_left,
		}
	var gc = info["grid_container"]
	ObjectUtils.set_info(gc, result)
	
	return result


static func center_inventory_anchors(options:Dictionary):
	# Data required for this function to work properly
	var required_data = {
			"cells_manager": CellsManager.new(),
			"inventory": Control.new(),
			"rows": 1,
		}
	var DictionaryUtils = load("res://godot-libs/libs/" + \
			"utils/dictionary_utils.gd")
	var valid_data = DictionaryUtils.validate_options(options, required_data)
	if(!valid_data):
		# Get outta here
		return
	
	var info = options["info"]
	
	# Load some modules
	var UIUtils = load("res://godot-libs/libs/utils/ui_utils.gd")
	var ObjectUtils = load("res://godot-libs/libs/utils/object_utils.gd")
	
	# Variables
	# Anchors final value will be stored here
	var anchor_top = 0
	var anchor_right = 0
	var anchor_bottom = 0
	var anchor_left = 0
	
	var cm = info["cells_manager"]
	var cells_min_size = cm["cells_min_size"]
	var debug = info["debug"] if info.has("debug") else false
	var length = cm["length"]
	var reliable_viewport = UIUtils.get_reliable_viewport()
	var rows = info["rows"]
	
	if(debug):
		print("UIExtra -> set_hotbar_panel_anchors(options:Dictionary):")
		print("Columns: ", length / rows)
		print("Rows: ", rows)
	
	var remaining_width = remaining_width(cells_min_size, length / rows,
			debug)
	var remaining_height = remaining_height(cells_min_size, rows,
			debug)
	var horizontal_space = UIUtils.get_x_pixel_percentage(remaining_width / 2)
	var vertical_space = UIUtils.get_y_pixel_percentage(remaining_height / 2)
	anchor_top = vertical_space
	anchor_right = 1 - horizontal_space
	anchor_bottom = 1 - vertical_space
	anchor_left = horizontal_space
	
	if(debug):
		print("Result: ")
		print("Anchor left: ", anchor_left)
		print("Anchor top: ", anchor_top)
		print("Anchor right: ", anchor_right)
		print("Anchor bottom: ", anchor_bottom)
	
	# Result
	var result = {
			# Clockwise order
			"anchor_top": anchor_top,
			"anchor_right": anchor_right,
			"anchor_bottom": anchor_bottom,
			"anchor_left": anchor_left,
		}
	var inventory = info["inventory"]
	ObjectUtils.set_info(inventory, result)
	
	# Update rect min size
	var inventory_width = inventory_width(cells_min_size, length / rows)
	var inventory_height = inventory_height(cells_min_size, rows)
	var inventory_size = Vector2(inventory_width, inventory_height)
	
	if(debug):
		print("Inventory size: ", inventory_size)
	
	ObjectUtils.set_info(inventory, {
		"rect_size": inventory_size,
		"rect_min_size": inventory_size,
	})
	
	return result
