extends Control

# Objectives:
# [] Do an ui that works with the inventory class
# [] Second click on an item shows some options
#   [] Lock/Unlock item
#   [] Drop item
#   [] Move
#     [] Right
#     [] Down
#     [] Left
#     [] Up

var cells_manager = preload("res://godot-libs/inventory_ui/" + \
		"cells_manager/cells_manager.gd") setget , get_cells_manager
var debug:bool = false setget set_debug, get_debug
var debug_first_half:String = "Inventory(ui) -> "

func _init(options = { "debug": false, }) -> void:
	# Check if it has debug also check if the type is boolean
	if(options.has(debug) && typeof(options.debug) == TYPE_BOOL):
		self.debug = options.debug
	if(self.debug):
		print(debug_first_half, "_init():")


func _ready():
	if(self.debug):
		print(debug_first_half, "_ready():")
	
	var grid_container = $BackgroundColor/ScrollContainer/GridContainer
	
	if(self.debug):
		print("Grid container: ", grid_container)
	
	# The cells manager will be in charge of creating and
	# rearranging the cells
	cells_manager = cells_manager.new({
		"info": {
			"debug": self.debug,
			"length": 0,
			"node_ref": grid_container
		},
	})


# Notifications
func _notification(what):
	match what:
		NOTIFICATION_MOUSE_ENTER:
			pass # Mouse entered the area of this control.
		NOTIFICATION_MOUSE_EXIT:
			pass # Mouse exited the area of this control.
		NOTIFICATION_FOCUS_ENTER:
			pass # Control gained focus.
		NOTIFICATION_FOCUS_EXIT:
			pass # Control lost focus.
		NOTIFICATION_THEME_CHANGED:
			pass # Theme used to draw the control changed;
			# update and redraw is recommended if using a theme.
		NOTIFICATION_VISIBILITY_CHANGED:
			pass # Control became visible/invisible;
			# check new status with is_visible().
		NOTIFICATION_RESIZED:
			pass # Control changed size; check new size
			# with get_size().
		NOTIFICATION_MODAL_CLOSE:
			pass # For modal pop-ups, notification
			# that the pop-up was closed.


func get_cells_manager():
	return cells_manager


func set_debug(value:bool) -> void:
	debug = value
func get_debug() -> bool:
	return debug


func get_inventory():
	return self.cells_manager.inventory
