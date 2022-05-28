extends CanvasLayer
class_name InventoryManager

signal inventory_added(added_inv)

# The length will likely be overrided
export(bool) var debug:bool = false setget set_debug, get_debug

var ObjectUtils = preload("res://godot-libs/libs/utils/object_utils.gd")

func _init():
	if(debug):
		print("InventoryManager -> _init:")
	
	# Connect to the cells changed for instancing and destroying cells
	var _connect_result = connect(
			"cells_changed", self, "_on_inventory_manager_cells_changed")


func get_inventory_scene(name:String):
	if(self.debug):
		print("InventoryManager -> get_inventory_scene(name):")
		print("Name: ", name)
	
	var scene
	
	match(name):
		"InventoryUI":
			scene = "res://godot-libs/inventory_ui/inventory/inventory.tscn"
		"Hotbar":
			scene = "res://godot-libs/inventory_ui/hotbar/hotbar.tscn"
		_:
			if(self.debug):
				print("Scene not found!, name provided: ", name)
			return null
	
	scene = load(scene)
	
	return scene


# Add inventory scene
# Returns a reference to it
func add_inventory_scene(scene:PackedScene, options={ "properties": { } }):
	if(self.debug):
		print("InventoryManager -> add_inventory_scene:")
	
	var new_scene = scene.instance()
	ObjectUtils.set_info(new_scene, options["properties"])
	
	if(new_scene.get("debug")):
		new_scene.debug = self.debug
	
	add_child(new_scene)
	emit_signal("inventory_added", new_scene)
	
	# On success return the scene
	return new_scene
func add_interface(scene:PackedScene, options={ "properties": { } }):
	if(self.debug):
		print("InventoryManager -> add_interface:")
	return add_inventory_scene(scene, options)


func add_inventory_by_name(name:String, options={ "properties": { } }):
	return add_inventory_scene(get_inventory_scene(name), options)


# setget debug
func set_debug(value:bool) -> void:
	debug = value
func get_debug() -> bool:
	return debug
