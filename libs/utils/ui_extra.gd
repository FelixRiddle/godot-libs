class_name UIExtra

# dict1 is the provided dictionary
static func key_exists_and_types_match(dict1, dict2, key):
	return dict1.has(key) != null && \
			typeof(dict1[key]) == typeof(dict2[key])


static func validate_cells_options(options:Dictionary={
		"default_info": true,
		"info": {} }):
	
	print("Information given: ", options)
	
	if(options.has("default_info") && options["default_info"]):
		print("[-] Default information given")
		# Get outta here
		return
	
	var data_placeholder = {
			"cells": Node.new(),
			"debug": false,
			"grid_container": Node.new(),
			"length": 1,
		}
	var info
	if(options.has("info")):
		info = options["info"]
		
		if(typeof(info) == TYPE_DICTIONARY):
			for key in data_placeholder.keys():
				if(!key_exists_and_types_match(info, data_placeholder, key)):
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
				if(!key_exists_and_types_match(info, data_placeholder, key)):
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
		print("UIExtra -> set_automatic_size():")
	
	# Variables
	# Space between cells in pixels
	# Here, 0.01 is equal to 1%
	# Therefore, the result will be 1% of the screen width
	var space_between_cells = reliable_viewport.x \
			* 0.01
	# Width of all cells combined
	var combined_cells_width = cell_min_size * length
	# We multiply the space between cells by the amount of cells we have + 2
	# because there will also be a space at the start and at the end
	var full_space_width = (space_between_cells * (length + 2))
	# Full hotbar width
	var full_width = combined_cells_width + full_space_width
	# Get the remaining width, in the rare case that the full_width is larger
	# than the screen width, then it would break
	var remaining_width = reliable_viewport.x - full_width
	# The remaining width / 2 will be the space between the start of the screen
	# and the hotbar, it will also be the space from the end of the hotbar to
	# the end of the screen
	var space = remaining_width / 2
	
	if(debug):
		print("Cells min size: ", cell_min_size)
		print("Space between cells: ", space_between_cells)
		print("Combined cells width: ", combined_cells_width)
		print("Full space width: ", full_space_width)
		print("Full width: ", full_width)
		print("Remaining width: ", remaining_width)
		print("Space: ", space)
	
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
	
	# Set anchor bottom
	# Top and bottom space
	var y_cell_space = space_between_cells * 2
	# Add the cell space and the cell width/height
	var full_height = y_cell_space + cell_min_size
	var remaining_height = reliable_viewport.y - full_height
	# Because the anchor_bottom starts at 1
	var y_space = 1 - UIUtils.get_y_pixel_percentage(remaining_height)
	if(debug):
		print("Full height: ", full_height)
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
