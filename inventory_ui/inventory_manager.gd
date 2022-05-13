extends CanvasLayer

signal inventory_added(added_inv)

# The length will likely be overrided
export(bool) var debug:bool = false setget set_debug, get_debug

func _init():
	if(debug):
		print("InventoryManager -> _init:")
	
	# Connect to the cells changed for instancing and destroying cells
	var connect_result = connect(
			"cells_changed", self, "_on_inventory_manager_cells_changed")
	
	if(debug):
		print("Connect result: ", connect_result)


# Add inventory scene
# Returns a reference to it
func add_inventory_scene(scene:PackedScene):
	var new_scene = scene.instance()
	add_child(new_scene)
	
	emit_signal("inventory_added", new_scene)
	
	# On success return true
	return new_scene
func add_interface(node):
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
