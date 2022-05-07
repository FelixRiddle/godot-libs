extends "res://Scripts/Inventory/Items/Types/Weapons/Weapon.gd"

# This class name
class_name Bow

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
	}
