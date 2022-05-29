class_name UIUtils

# Windows size
static func get_reliable_viewport() -> Vector2:
	return Vector2(ProjectSettings.get_setting("display/window/size/width"), \
		ProjectSettings.get_setting("display/window/size/height"))


# The dirty work
# These functions can be used to set the anchors
static func get_x_pixel_percentage(pixels:float,
		multiply_by_100:bool=false) -> float:
	var w_size = get_reliable_viewport()
	var result = pixels / w_size.x
	
	if(multiply_by_100):
		return result * 100
		
	return result


static func get_y_pixel_percentage(pixels:float,
		multiply_by_100:bool=false) -> float:
	var w_size = get_reliable_viewport()
	var result = pixels / w_size.y
	
	if(multiply_by_100):
		return result * 100
	
	return result
