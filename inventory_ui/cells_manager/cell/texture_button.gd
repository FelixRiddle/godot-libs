extends TextureButton

# Objectives:
# [] Do an ui that works with the inventory class
# [] Second click on an item shows some options
#   [] Lock/Unlock item
#   [] See details
#   [] Drop item
#   [] Move
#     [] Right
#     [] Down
#     [] Left
#     [] Up


# Notifications
func _notification(what):
	# TODO: Cell actions when the cursor moves around the cells
	match what:
		NOTIFICATION_MOUSE_ENTER: # Mouse entered the area of this control.
			# Show item description
			
			pass
		NOTIFICATION_MOUSE_EXIT: # Mouse exited the area of this control.
			# Hide item description
			
			pass
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
