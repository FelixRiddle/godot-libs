extends Control

var ObjectUtils = preload("res://godot-libs/libs/utils/object_utils.gd")
var UIExtra = preload("res://godot-libs/libs/utils/ui_extra.gd")
var UIUtils = preload("res://godot-libs/libs/utils/ui_utils.gd")

export(int) var length:int = 0
export(int) var rows:int = 1
export(int) var ui_rows:int = 4

onready var cells_manager = find_node("CellsManager")

var debug = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var cm = cells_manager
	
	if(debug):
		print("HotbarV2 -> _ready():")
	cm.can_grab_focus = false
	cm.set_cell_type(2)
	
	if(debug):
		print("Length: ", length)
		print("Setting length")
	ObjectUtils.set_info(
		cm,
		{
			"debug": debug,
			"length": length,
		})
	
	if(debug):
		print("Cells manager length: ", cm.length)
		print("Cells manager type: ", typeof(cm))
	
	# Changing the size and the anchors
	var background_color = find_node("BackgroundColor")
	var anchors = UIExtra.center_inventory_anchors({
			"info": {
				"columns": 9,
				"debug": false,
				"cells_manager": cm,
				"inventory": self,
				"rows": ui_rows,
			}
		})
	
	# We add a little offset to center it
	var space = UIExtra.space_between_cells()
	var h_anchor_space = UIUtils.get_x_pixel_percentage(space)
	var v_anchor_space = UIUtils.get_y_pixel_percentage(space)
	var sc = find_node("ScrollContainer")
	if(ui_rows >= rows):
		sc.anchor_top += v_anchor_space * 1.6
		sc.anchor_right -= h_anchor_space * 2
		sc.anchor_bottom -= v_anchor_space * 1.6
		sc.anchor_left += h_anchor_space * 2
	elif(ui_rows < rows):
		self.anchor_right += h_anchor_space * 3
		self.anchor_bottom += v_anchor_space * 1.6
		
		sc.anchor_top += v_anchor_space * 2
		sc.anchor_right -= h_anchor_space * 2
		sc.anchor_bottom -= v_anchor_space * 2
		sc.anchor_left += h_anchor_space * 2
	
	if(debug):
		print("Horizontal anchor space: ", h_anchor_space)
		print("Vertical anchor space: ", v_anchor_space)
	
	cm.update_cells_size()
	
	cm.add_constant_override("hseparation", space)
	cm.add_constant_override("vseparation", space)


func _input(event):
	cells_manager.middle_mouse_manager()


func get_inventory_script():
	return cells_manager.inventory
func add_item_by_id(item_id, amount):
	return cells_manager.inventory.add_item_by_id({
		"id": item_id,
		"amount": amount,
	})
