tool
extends Node2D

var DictionaryUtils = preload(
		"res://godot-libs/libs/utils/dictionary_utils.gd")

export(int) var item_amount:int = 1
export(String, MULTILINE) var item_description:String = "Description"
export(int) var item_id:int = 0
export(Texture) var item_image setget set_item_image, get_item_image
export(String) var item_name:String = "Item"
export(String) var player_name:String = "Player"

func _ready():
	var sprite:Sprite = $Sprite
	sprite.texture = item_image


func set_item_image(value) -> void:
	item_image = value
	
	var sprite:Sprite = $Sprite
	if(sprite != null):
		sprite.texture = item_image
func get_item_image():
	return item_image


func _on_PickupArea_body_entered(body):
	if(body.name == player_name && body.has_method("pick_item")):
		var properties_dictionary = DictionaryUtils.get_as_dict(
				self, [
					"item_amount",
					"item_description",
					"item_id",
					"item_image",
					"item_name"
				])
		properties_dictionary["item_image"] = item_image.duplicate()
		body.pick_item(properties_dictionary)
		queue_free()
