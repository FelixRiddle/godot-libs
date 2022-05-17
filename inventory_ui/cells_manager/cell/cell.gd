extends Control

# Objectives:
# [] Do an ui that works with the inventory class
# [] Second click on an item shows some options
#   [] Lock/Unlock item
#   [] See details
#   [] Drop item
#   [] Move
#     [] Right
#     [] Down
#     [] Left
#     [] Up

signal updated

onready var texture_button:TextureButton = $TextureButton

var updated:bool = false setget set_updated, get_updated

func _ready():
	if(rect_min_size.x <= 0.01 || rect_min_size.y <= 0.01):
		var five_percent_viewport = get_viewport().size.x * .05
		rect_min_size = Vector2(five_percent_viewport, five_percent_viewport)


# setget updated
func set_updated(value:bool) -> void:
	updated = value
	
	if(self.updated):
		emit_signal("updated")
func get_updated() -> bool:
	return updated
