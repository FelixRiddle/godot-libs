tool
extends Node

class_name InventoryTest

var Inventory = load("res://Scripts/Inventory/Inventory.gd")

# Constructor
func _init():
	#add_one_item()
	#cumulative_test()
	inventory_full_test()

func add_one_item():
	print(" --- Inventory ---")
	var inv = Inventory.new({"debug": true})
	inv.set_size(10)
	print("Inventory size: %s" % inv.get_size())
	
	print("Slots free: ", inv.get_empty_slots())
	
	# id, amount
	inv.add_item_by_id(1, 3)
	
	print("Slots free: ", inv.get_empty_slots())
	
	#inv.print_items_as_dict()
	print("Inventory items: %s" % inv.get_items())
	
	# The actual hard part
	inv.add_item_by_id(1, 10)
	
	print("Empty slots: ", inv.get_empty_slots())
	print("Used slots: ", inv.get_used_slots_array())
	print("Inventory length: ", inv.items.size())
	print("Inventory keys: ", inv.items.keys())
	
	# Remove items
	inv.remove_item_by_uuid(inv.items.keys()[0])
	inv.remove_item_by_uuid(inv.items.keys()[0])
	inv.remove_item_by_uuid(inv.items.keys()[0])
	print("Three items deleted")
	print("Empty slots: ", inv.get_empty_slots())
	
	# It's possible to use brackets for properties
	print("Size: ", inv["size"])
	
	# Add a cumulative item
	inv.add_item_by_id(10001, 100)
	print("Empty slots: ", inv.get_empty_slots())
	var healing_potion = inv.get_items_by_id(10001)[0]
	print("Healing potions capacity: ", healing_potion.get_capacity())
	print("Amount of healing potions: ", healing_potion.get_amount())
	
	print("Adding 899 potions")
	inv.add_item_by_id(10001, 899)
	print("Healing potions capacity: ", healing_potion.get_capacity())
	print("Amount of healing potions: ", healing_potion.get_amount())
	
	print("Adding 1 potion")
	inv.add_item_by_id(10001, 1)
	print("Healing potions capacity: ", healing_potion.get_capacity())
	print("Amount of healing potions: ", healing_potion.get_amount())
	
	print("Adding 1 potion")
	inv.add_item_by_id(10001, 1)
	print("Healing potions capacity: ", healing_potion.get_capacity())
	print("Amount of healing potions: ", healing_potion.get_amount())
	var healing_potion_slots = inv.get_items_by_id(10001)
	print("Healing potion slots: ", healing_potion_slots)
	print("Slots available: ", inv.get_empty_slots())
	
	loop_and_print_amount(healing_potion_slots)
	#3#
	inv.print_items_name_array()

func cumulative_test():
	print(" --- Inventory Cumulative Test ---")
	var inv = Inventory.new({"debug": true})
	inv.set_size(10)
	print("Inventory size: %s" % inv.get_size())
	print("Slots free: ", inv.get_empty_slots())
	
	var potions
	
	inv.add_item_by_id(10001, 999)
	potions = inv.get_items_by_id(10001)
	print("Potions slots in inventory: ", potions)
	loop_and_print_amount(potions)
	
	print("Adding one more")
	inv.add_item_by_id(10001, 1)
	potions = inv.get_items_by_id(10001)
	print("Potions slots in inventory: ", potions)
	loop_and_print_amount(potions)
	
	###
	print("Adding 900 more")
	inv.add_item_by_id(10001, 900)
	potions = inv.get_items_by_id(10001)
	print("Potions slots in inventory: ", potions)
	loop_and_print_amount(potions)
	
	############
	print("Adding 1200 more")
	inv.add_item_by_id(10001, 1200)
	potions = inv.get_items_by_id(10001)
	print("Potions slots in inventory: ", potions)
	loop_and_print_amount(potions)
	
	# Now the fourth slot should have 100
	inv.print_items_name_array()
#
func inventory_full_test():
	print(" --- Inventory ---")
	var inv = Inventory.new({"debug": true})
	inv.set_size(10)
	print("Inventory size: %s" % inv.get_size())
	
	print("Slots free: ", inv.get_empty_slots())
	
	# id, amount
	inv.add_item_by_id(1, 12)
	inv.print_items_name_array()
	
	var fifth_slot = inv.get_item_in_slot(5)
	print("Fifth slot item name: ", fifth_slot.get_name())
	#####
	inv.remove_item_by_slot(5)
	fifth_slot = inv.get_item_in_slot(5)
	inv.print_items_name_array()
	inv.print_used_slots()
	#
	# The potions have a max of 1000
	inv.add_item_by_id(10001, 1001)
	inv.print_items_name_array()
	inv.print_used_slots()
	print("Amount of potions: ", inv.get_item_in_slot(5).get_amount())

# Loop and print the amount property of a given array of Items
func loop_and_print_amount(arr):
	if(!arr):
		return print("No array given")
	
	for i in range(arr.size()):
		var curr_item = arr[i]
		
		if(curr_item.has_method("get_amount") && \
				curr_item.has_method("get_name")):
			print("Item ", i, " ", curr_item.get_name(), " amount is: ", \
				curr_item.get_amount())

func counting_sort():
	var Sort = load("res://Scripts/Libs/Sort.gd")
	
	print(" --- Counting sort test ---")
	var arr = [61, 3, 1, 2, 5, 8, 10, 4, 12, 6, 0, 7, 9, 11, 5, 8, 7, 3, 2,
		1, 1, 1, 0, 0, 20, 50]
	print("Array: ", arr)
	print("Array length: ", arr.size())
	
	var sorted_array = Sort.counting_sort(arr)
	print("Sorted array: ", sorted_array)
