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

onready var cells_manager = load( "res://godot-libs/inventory_ui/" + \
		"cells_manager/cells_manager.gd").new({
				"info": {
					"debug": true,
					"length": 0,
					"node_ref": get_node("BackgroundColor/HSplitContainer" + \
							"/Panel/GridContainer"),
				},
		}) setget , get_cells_manager

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


func get_inventory():
	return self.cells_manager.inventory
