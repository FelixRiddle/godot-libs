class_name Weapon
extends "res://godot-libs/inventory/items/item.gd"

# Properties
export var item_damage = 0 setget set_damage, get_damage

### Functions/Methods ###
### Item damage
func set_damage(value):
	item_damage = value
func get_damage():
	return item_damage
