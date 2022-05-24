extends Node

var obj setget set_obj, get_obj
var opacity_manager = preload("res://godot-libs/libs/objects/opacity" + \
		"/opacity_manager.gd").new()

# The root node of an object scene, no a "stage" scene
func _init(obj_ref=null, options={ "opacity_manager": true, }):
	self.obj = obj_ref
	obj_ref.print_tree_pretty()
	if(options.has("opacity_manager") && options["opacity_manager"]):
		opacity_manager.enable(obj_ref)


# setget object(object scene root node) reference
func set_obj(value) -> void:
	if value is Node:
		obj = value
func get_obj():
	return obj
