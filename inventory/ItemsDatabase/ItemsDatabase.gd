class_name ItemsDatabase

### Functions/Methods ###
# Get every item
static func get_items():
	
	# Predefined items
	# 1-10000 Weapons
	# 10001-20000 Potions/Food/Others
	var items = {
		1: {
			"capacity": 1,
			"class_id": get_item_classes_and_id()["sword"]["id"],
			"class_path": get_item_classes_and_id()["sword"]["path"],
			"damage": 1,
			"description": "What description can a Wooden Sword have?",
			"item_id": 1,
			"name": "Wooden Sword",
			"scene_path": "res://Scenes/Items/Weapons/WoodenSword",
			"subtype": "sword",
			"type": "weapon",
		},
		2: {
			"capacity": 1,
			"class_id": get_item_classes_and_id()["sword"]["id"],
			"class_path": get_item_classes_and_id()["sword"]["path"],
			"damage": 1.2,
			"description": "A stick found in the wild",
			"item_id": 2,
			"name": "Stick",
			"scene_path": "res://Scenes/Items/Weapons/Stick",
			"subtype": "sword",
			"type": "weapon",
		}, # Potions/Food/Others
		10_001: {
			"capacity": 1000,
			"class_id": get_item_classes_and_id()["healing_potion"]["id"],
			"class_path": get_item_classes_and_id()["healing_potion"]["path"],
			"description": "A minor healing potion, heals 30 HP instantly",
			"heal": 30,
			"item_id": 10001,
			"name": "Minor Healing Potion",
			"scene_path": "res://Scenes/Items/Potions/MinorHealingPotion",
			"subtype": "healing",
			"type": "potion",
		},
		10_002: {
			"capacity": 1000,
			"class_id": get_item_classes_and_id() \
				["unknown_healing_potion"]["id"],
			"class_path": get_item_classes_and_id() \
				["unknown_healing_potion"]["path"],
			"description": "Unknown potion, only one way to find out",
			"item_id": 10002,
			"name": "Unknown Potion",
			"scene_path": "res://Scenes/Items/Potions/UnknownPotion",
			"subtype": "unknown_healing_potion",
			"type": "potion",
		}, # Herbs
		11_001: {
			"capacity": 1000,
			"class_id": get_item_classes_and_id() \
				["healing_herb"]["id"],
			"class_path": get_item_classes_and_id() \
				["healing_herb"]["path"],
			"description": "A herb found in the wild, heals 100 HP over " + \
				"12 seconds",
			"heal": 100,
			"item_id": 11001,
			"name": "Minor Healing Herb",
			"scene_path": "res://Scenes/Items/Herbs/MinorHealingHerb",
			"subtype": "healing",
			"type": "herb",
			"heal_time_span": 12,
		},
		11_002: {
			"capacity": 1000,
			"class_id": get_item_classes_and_id() \
				["unknown_healing_herb"]["id"],
			"class_path": get_item_classes_and_id() \
				["unknown_healing_herb"]["path"],
			"description": "An unknown herb, only one way to find out",
			"item_id": 11002,
			"name": "Unknown Herb",
			"scene_path": "res://Scenes/Items/Herbs/UnknownHerb",
			"subtype": "unknown_healing_herb",
			"type": "herb",
		}
	}
	return items

static func get_fields_as_string_array():
	return ["capacity", "class_id", "class_path", "description",
		"heal_time_span", "id", "name", "scene_path", "subtype", "time_span",
		"type", ]

# Get item classes and ids
static func get_item_classes_and_id():
	return {
		# Weapons
		"sword": {
			"id": 1,
			"path": \
				"res://Scripts/Inventory/Items/Types/Weapons/Types/Sword.gd"
		},
		"mace": {
			"id": 2,
			"path": \
				"res://Scripts/Inventory/Items/Types/Weapons/Types/Mace.gd"
		},
		"bow": {
			"id": 3,
			"path": \
				"res://Scripts/Inventory/Items/Types/Weapons/Types/Bow.gd"
		},
		# Armor
		"helmet": {
			"id": 11,
			"path": \
				"res://Scripts/Inventory/Items/Types/Armor/Types/Helmet.gd"
		},
		"torso": {
			"id": 12,
			"path": \
				"res://Scripts/Inventory/Items/Types/Armor/Types/Torso.gd"
		},
		"gauntlets": {
			"id": 13,
			"path": \
				"res://Scripts/Inventory/Items/Types/Armor/Types/Gauntlets.gd"
		},
		"greaves": {
			"id": 14,
			"path": \
				"res://Scripts/Inventory/Items/Types/Armor/Types/Greaves.gd"
		},
		"boots": {
			"id": 15,
			"path": \
				"res://Scripts/Inventory/Items/Types/Armor/Types/Boots.gd"
		},
		# Extra
		"bracelet": {
			"id": 21,
			"path": \
				"res://Scripts/Inventory/Items/Types/Extra/Bracelet.gd"
		},
		"necklace": {
			"id": 22,
			"path": \
				"res://Scripts/Inventory/Items/Types/Extra/Necklace.gd"
		},
		# Herbs
		"healing_herb": {
			"id": 31,
			"path": \
				"res://Scripts/Inventory/Items/Types/Herbs/Types/HealingHerb.gd"
		},
		"unknown_healing_herb": {
			"id": 32,
			"path": \
				"res://Scripts/Inventory/Items/Types/Herbs/" + \
				"Types/UnknownHealingHerb.gd"
		},
		# Potions
		"healing_potion": {
			"id": 41,
			"path": \
				"res://Scripts/Inventory/Items/Types/Potions/" + \
				"Types/HealingPotion.gd"
		},
		"unknown_healing_potion": {
			"id": 42,
			"path": \
				"res://Scripts/Inventory/Items/Types/Potions/" + \
				"Types/UnknownHealingPotion.gd"
		},
	}

# Get an item by id(key)
static func get_item_by_id(id):
	return get_items()[id]
