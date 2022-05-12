extends "res://godot-libs/inventory/items/types/weapons/weapon.gd"

# This class name
class_name Sword

# To call parent constructor
#func _init(_data, _options).(parent_args):
#var class_path = "res://Scripts/Inventory/Items/Types/Weapons/" + \
#	"Types/Sword.gd"


# Constructor
func _init(_data, _options):
	if(_data.has("debug")):
		print("Sword.gd -> _init(_data, _options):")
	
	set_info(_data)
	set_sword_info(_data)


### Functions/Methods ###
# Set sword info
func set_sword_info(item):
	if(debug):
		print("Sword.gd -> set_sword_info(item):")
	
	if(item):
		if(item.has("damage")):
			self.item_damage = item["damage"]


### Methods/Functions ###
# Return variables in as a dictionary
func get_as_dict():
	if(debug):
		print("Sword.gd -> get_as_dict():")
	var result = _get_item_stats_as_dict()
	
	if(get("item_damage")):
		result["damage"] = self.item_damage
	
	return result
