class_name Weapon
extends "res://Scripts/Inventory/Items/Item.gd"

# Properties
export var item_damage = 0 setget set_damage, get_damage

### Functions/Methods ###
### Item damage
func set_damage(value):
	item_damage = value
func get_damage():
	return item_damage
