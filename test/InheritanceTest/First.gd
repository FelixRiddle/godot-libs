var overflow = 0

export var item_overflow = 0
export var item_amount = 0 setget set_amount, get_amount
export var item_capacity = 1

### Amount
func set_amount(value):
	var old_amount = item_amount
	
	# There is space to store the items
	if(item_capacity >= item_amount + value):
		item_amount = value
	else: # There is not enough space
		var space_available = item_capacity - item_amount
		
		# We know because of the first check that value is bigger than
		# the space available
		var remaining_items = value - space_available
		
		# Fill it up
		item_amount = item_capacity
		
		# Set the overflow to the remaining items, but we don't know for sure
		# if item_overflow is empty, so we add items to it
		item_overflow += remaining_items
	emit_signal("amount_changed", old_amount, item_amount)

func get_amount():
	return item_amount
