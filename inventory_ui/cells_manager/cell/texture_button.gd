extends TextureButton

func _init():
	pass

# Notifications
func _notification(what):
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
