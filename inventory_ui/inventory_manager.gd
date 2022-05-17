extends CanvasLayer
class_name InventoryManager

signal inventory_added(added_inv)

# The length will likely be overrided
export(bool) var debug:bool = false setget set_debug, get_debug

func _init():
	if(debug):
		print("InventoryManager -> _init:")
	
	# Connect to the cells changed for instancing and destroying cells
	var _connect_result = connect(
			"cells_changed", self, "_on_inventory_manager_cells_changed")


# Add inventory scene
# Returns a reference to it
func add_inventory_scene(scene:PackedScene):
	if(self.debug):
		print("InventoryManager -> add_inventory_scene:")
	
	var new_scene = scene.instance()
	
	if(new_scene.get("debug")):
		new_scene.debug = self.debug
	
	add_child(new_scene)
	
	emit_signal("inventory_added", new_scene)
	
	# On success return the scene
	return new_scene
func add_interface(node):
	if(self.debug):
		print("InventoryManager -> add_interface:")
	return add_inventory_scene(node)


# setget debug
func set_debug(value:bool) -> void:
	debug = value
func get_debug() -> bool:
	return debug


func set_info(options:Dictionary) -> void:
	if(options.has("debug") \
			&& typeof(options["debug"]) == TYPE_BOOL):
		self.debug = options["debug"]
	if(debug):
		print("InventoryManager -> set_info:")
