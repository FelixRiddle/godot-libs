extends Panel

# Get the stylebox used by this panel
var stylebox_flat = preload("res://godot-libs/inventory_ui/cells_manager/" + \
		"cell/panel_stylebox_flat.tres").duplicate()
var mouse_enter_color = Color(90, 90, 90, 127)
var mouse_leave_color = Color(44, 44, 44, 127)

func _init():
	
	self.add_stylebox_override("panel_stylebox", stylebox_flat)
#	print("Stylebox flat: ", stylebox_flat)
#	print("Typeof: ", typeof(stylebox_flat))
#	print("Has property bg_color?: ", stylebox_flat.get("bg_color"))
#	print("Has stylebox_flat: ", has_stylebox_override("panel_stylebox"))
	pass

# Notifications
func _notification(what):
	match what:
		NOTIFICATION_MOUSE_ENTER: # Mouse entered the area of this control.
			if(!stylebox_flat):
				return
			
			# Make it lighter
			stylebox_flat.bg_color = mouse_enter_color
			#print("Mouse enter, color changed to: ", stylebox_flat.bg_color)
			
			pass
		NOTIFICATION_MOUSE_EXIT: # Mouse exited the area of this control.
			if(!stylebox_flat):
				return
			
			# Set default color
			stylebox_flat.bg_color = mouse_leave_color
			#print("Mouse leave, color changed to: ", stylebox_flat.bg_color)
			
			pass
		NOTIFICATION_FOCUS_ENTER:
			if(!stylebox_flat):
				return
			
			pass # Control gained focus.
		NOTIFICATION_FOCUS_EXIT:
			if(!stylebox_flat):
				return
			
			pass # Control lost focus.
		NOTIFICATION_THEME_CHANGED:
			if(!stylebox_flat):
				return
			
			pass # Theme used to draw the control changed;
			# update and redraw is recommended if using a theme.
		NOTIFICATION_VISIBILITY_CHANGED:
			if(!stylebox_flat):
				return
			
			pass # Control became visible/invisible;
			# check new status with is_visible().
		NOTIFICATION_RESIZED:
			if(!stylebox_flat):
				return
			
			pass # Control changed size; check new size
			# with get_size().
		NOTIFICATION_MODAL_CLOSE:
			if(!stylebox_flat):
				return
			
			pass # For modal pop-ups, notification
			# that the pop-up was closed.
