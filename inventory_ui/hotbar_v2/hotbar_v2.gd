extends Control

var UIExtra = preload("res://godot-libs/libs/utils/ui_extra.gd")
var ObjectUtils = preload("res://godot-libs/libs/utils/object_utils.gd")

export(int) var length:int = 0

onready var cm = $CellsManager

var debug = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("HotbarV2 -> _ready():")
	cm.can_grab_focus = true
	cm.set_cell_type(2)
	print("Length: ", length)
	print("Setting length")
	ObjectUtils.set_info(
		cm,
		{
			"debug": debug,
			"length": length,
		})
	print("Restoring focus: ")
	cm.restore_focus()
	print("Cells manager length: ", cm.length)
	print("Cells manager type: ", typeof(cm))
	
	# Changing the size and the anchors
	var anchors = UIExtra.set_hotbar_panel_anchors({
			"info": {
				"cells_min_size": cm.cells_min_size,
				"debug": debug,
				"grid_container": cm,
				"length": cm.length,
			}
		})
	cm.update_cells_size()
	
	UIExtra.set_cells_position({
		"info": {
			"cells": cm.cells,
			"cells_manager": cm,
			"debug": debug,
			"length": cm.length,
		}
	})


func _input(event):
	cm.middle_mouse_manager()
