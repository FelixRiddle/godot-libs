extends "res://godot-libs/inventory/items/item.gd"


func _init(_data, _options):
	create(_data)

### Functions/Methods ###
# Create a new item
func create(item):
	# Check if the item exists
	var new_item = find(item)
	if(new_item):
		item = new_item
	
	# If the value provided is null, default to create a uuid
	var new_id = item["id"]
	if item["id"] == null:
		new_id = uuid_util.v4()
	self.item_id = new_id
	
	self.item_name = item["name"]
	self.item_description = item["description"]
	self.item_type = item["type"]
