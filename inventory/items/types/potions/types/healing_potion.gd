extends "res://godot-libs/inventory/items/types/potions/potion.gd"

class_name HealingPotion

export var heal = 0 setget set_heal, get_heal

# Constructor
func _init(_data, _options):
	if(_data.get("debug")):
		print("HealingPotion.gd -> _init(_data, _options):")
	
	set_info(_data)
	_set_healing_potion_info(_data)

### Functions/Methods ###
# Set information about this item
func _set_healing_potion_info(item):
	if(debug):
		print("HealingPotion.gd -> _set_healing_potion_info(item):")
	
	if(item):
		if(item.get("heal")):
			self.heal = item["heal"]

# Return variables in as a dictionary
func get_as_dict():
	if(debug):
		print("HealingPotion.gd -> get_as_dict():")
	var result = _get_item_stats_as_dict()
	
	if(get("heal")):
		result["heal"] = self.heal
	
	return result

### Heal
func set_heal(value):
	heal = value
func get_heal():
	return heal
