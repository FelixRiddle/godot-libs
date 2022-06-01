extends Control

var ObjectUtils = preload("res://godot-libs/libs/utils/object_utils.gd")
var UIExtra = preload("res://godot-libs/libs/utils/ui_extra.gd")
var UIUtils = preload("res://godot-libs/libs/utils/ui_utils.gd")

export(int) var length:int = 0
export(int) var rows:int = 1
export(int) var ui_rows:int = 4

onready var cm = find_node("CellsManager")

var debug = true

# Called when the node enters the scene tree for the first time.
func _ready():
	print("HotbarV2 -> _ready():")
	cm.can_grab_focus = false
	cm.set_cell_type(2)
	print("Length: ", length)
	print("Setting length")
	ObjectUtils.set_info(
		cm,
		{
			"debug": debug,
			"length": length,
		})
	print("Cells manager length: ", cm.length)
	print("Cells manager type: ", typeof(cm))
	
	# Changing the size and the anchors
	var background_color = find_node("BackgroundColor")
	var anchors = UIExtra.center_inventory_anchors({
			"info": {
				"columns": 9,
				"debug": false,
				"cells_manager": cm,
				"inventory": background_color,
				"rows": ui_rows,
			}
		})
	ObjectUtils.set_info($CellsContainer, anchors)
	
	# We add a little offset to center it
	var space = UIExtra.space_between_cells()
	var h_anchor_space = UIUtils.get_x_pixel_percentage(space)
	var v_anchor_space = UIUtils.get_y_pixel_percentage(space)
	var sc = find_node("ScrollContainer")
	if(ui_rows >= rows):
		sc.anchor_top += v_anchor_space * 1.6
		sc.anchor_right += h_anchor_space * 2
		sc.anchor_bottom += v_anchor_space * 1.6
		sc.anchor_left += h_anchor_space * 2
	elif(ui_rows < rows):
		sc.anchor_top += v_anchor_space * 2
		sc.anchor_right += h_anchor_space * 2
		sc.anchor_bottom += v_anchor_space * 2
		sc.anchor_left += h_anchor_space * 2
		
		background_color.anchor_right += h_anchor_space * 2
		background_color.anchor_bottom += v_anchor_space * 1.6
		
		
	print("Horizontal anchor space: ", h_anchor_space)
	print("Vertical anchor space: ", v_anchor_space)
	
	cm.update_cells_size()
	
	cm.add_constant_override("hseparation", space)
	cm.add_constant_override("vseparation", space)
#	UIExtra.set_cells_position({
#		"info": {
#			"cells": cm.cells,
#			"cells_manager": cm,
#			"debug": debug,
#			"length": cm.length,
#		}
#	})


func _input(event):
	cm.middle_mouse_manager()
