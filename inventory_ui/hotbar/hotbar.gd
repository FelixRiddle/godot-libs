extends Control

var debug:bool = false setget set_debug, get_debug
var debug_first_half:String = "Inventory(ui) -> "

var cells_manager = preload("res://godot-libs/inventory_ui/" + \
		"cells_manager/cells_manager.gd").new({
				"debug": self.debug,
				"length": 0,
				"node_ref": self,
		}) setget , get_cells_manager

func get_cells_manager():
	return cells_manager


func set_debug(value:bool) -> void:
	debug = value
	
	# Also set debug for the inventory class
	var val = cells_manager.get("debug")
	if(val != null):
		cells_manager.debug = self.debug
func get_debug() -> bool:
	return debug


func get_inventory():
	return self.cells_manager.inventory
