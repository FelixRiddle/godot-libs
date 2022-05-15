extends ScrollContainer

# Reference:
#https://godotengine.org/qa/675/how-to-clip-child-controls-to-parent-controls-rect-bounds
func _draw():
	VisualServer.canvas_item_set_clip(get_canvas_item(), true)
