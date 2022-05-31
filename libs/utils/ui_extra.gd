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
		length:int, debug:bool=false):
	var space_between_cells = space_between_cells()
	
	var combined_cells_height = cells_size * length
	# Set anchor bottom
	# Top and bottom space
	var full_space_height = space_between_cells * (length + 1)
	# Add the cell space and the cell width/height
	var inventory_height = full_space_height + cells_size
	
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
		length:int, debug:bool=false):
	var reliable_viewport = UIUtils.get_reliable_viewport()
	var inventory_width = inventory_width(cells_size, length)
	
	# Get the remaining width, in the rare case that the full_width is larger
	# than the screen width, then it would break
	var remaining_width = reliable_viewport.x - inventory_width
	
	if(debug):
		print("Remaining width: ", remaining_width)
		print("Space: ", remaining_width / 2)
	
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
		print("Space between the start of the screen to this node: ", \
				remaining_height / 2, "(remaining_height / 2).")
	
	return remaining_height


# dict1 is the provided dictionary
static func key_type_match(dict1, dict2, key):
	return dict1.has(key) && \
			typeof(dict1[key]) == typeof(dict2[key])


static func validate_cells_options(options:Dictionary={
		"default_info": true,
		"info": {} }):
	
	if(options.has("default_info") && options["default_info"]):
		print("[-] Default information given")
		# Get outta here
		return
	
	var data_placeholder = {
			"cells": [Node.new()],
			"cells_manager": TextureButton.new(),
			"debug": false,
			"length": 1,
		}
	var info
	if(options.has("info")):
		info = options["info"]
		
		if(typeof(info) == TYPE_DICTIONARY):
			for key in data_placeholder.keys():
				if(!key_type_match(info, data_placeholder, key)):
					print("[-] The key ", key, " wasn't given.")
					# Get outta here
					return
			
			return true
		else:
			print("[-] Info it's not a dictionary")
			# Get outta here
			return
	else:
		print("[-] Doesn't have info(data)")
		# Get outta here
		return


static func set_cells_position(options:Dictionary):
	if(!validate_cells_options(options)):
		# Get outta here
		return
	
	# TODO: Change the cells position based on the space,
	# and for that add the previous x position to the new cell plus
	# the space between cells
	var info = options["info"]
	
	var cells = info["cells"]
	var cm = info["cells_manager"]
	var debug = info["debug"]
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


static func validate_options(options:Dictionary={
		"default_info": true,
		"info": {},
		}):
	
	print("Information given: ", options)
	
	if(options.has("default_info") && options["default_info"]):
		print("[-] Default information given")
		# Get outta here
		return
	
	var data_placeholder = {
			"cells_min_size": 1.1,
			"debug": false,
			"grid_container": GridContainer.new(),
			"length": 1,
		}
	var info
	if(options.has("info")):
		info = options["info"]
		
		if(typeof(info) == TYPE_DICTIONARY):
			for key in data_placeholder.keys():
				if(!key_type_match(info, data_placeholder, key)):
					print("[-] The key ", key, " wasn't given.")
					# Get outta here
					return
			
			return true
		else:
			print("[-] Info it's not a dictionary")
			# Get outta here
			return
	else:
		print("[-] Doesn't have info(data)")
		# Get outta here
		return


# If required, call after setting the size for the cells
# Returns null if the information provided is wrong
static func set_hotbar_panel_anchors(options:Dictionary):
	print("set_hotbar_panel_anchors")
	if(!validate_options(options)):
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
	var debug = info["debug"]
	var length = info["length"]
	var reliable_viewport = UIUtils.get_reliable_viewport()
	
	if(debug):
		print("UIExtra -> set_hotbar_panel_anchors(options:Dictionary):")
	
	# Variables
	# Space between cells in pixels
	# Here, 0.01 is equal to 1%
	# Therefore, the result will be 1% of the screen width
	var space_between_cells = space_between_cells()
	
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
	
#	# Set anchor bottom
#	# Top and bottom space
#	var y_cell_space = space_between_cells * 2
#	# Add the cell space and the cell width/height
#	var full_height = y_cell_space + cell_min_size
#	var remaining_height = reliable_viewport.y - full_height
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
