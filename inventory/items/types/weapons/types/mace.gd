extends "res://godot-libs/inventory/items/types/weapons/weapon.gd"

# This class name
class_name Mace

export var item_splash_area = 0 setget set_splash_area, get_splash_area

### Methods/Functions ###
# Return variables in as a dictionary
func get_as_a_dict():
	return {
		"amount": self.item_amount,
		"capacity": self.item_capacity,
		"damage": self.item_damage,
		"description": self.item_description,
		"id": self.item_id,
		"name": self.item_name,
		"scene": self.item_scene,
		"slot": self.item_slot,
		"subtype": self.item_subtype,
		"type": self.item_type,
		"splash_area": self.item_splash_area,
	}

### Splash area
func set_splash_area(value):
	item_splash_area = value
func get_splash_area():
	return item_splash_area
