extends Control

signal updated

onready var texture_button:TextureButton = $TextureButton

var updated:bool = false setget set_updated, get_updated

func _ready():
	if(rect_min_size.x <= 0.01 || rect_min_size.y <= 0.01 && get_viewport()):
		var five_percent_viewport = get_viewport().size.x * .05
		rect_min_size = Vector2(five_percent_viewport, five_percent_viewport)
		#print("Min rect size changed, new min_rect_size: ", rect_min_size)


# Set and get amount item label
func set_item_amount(value:int) -> void:
	if(value > 1):
		var label:Label = $TextureButton/Amount
		label.text = String(value)
func get_item_amount() -> int:
	var label:Label = $TextureButton/Amount
	return int(label.text)


func get_amount_label():
	return $TextureButton/Amount


# setget item_image
func set_item_image(value) -> void:
	if(typeof(value) == TYPE_STRING):
		value = load(value)
	
	if(value is Texture):
		var texture_rect:TextureRect = $TextureButton/Control/ItemImage
		texture_rect.set_texture(value)
func get_item_image():
	var texture_rect:TextureRect = $TextureButton/Control/ItemImage
	return texture_rect.get_texture()


func get_item_image_texture_rect():
	return $TextureButton/Control/ItemImage


# setget updated
func set_updated(value:bool) -> void:
	updated = value
	
	if(self.updated):
		emit_signal("updated")
func get_updated() -> bool:
	return updated
