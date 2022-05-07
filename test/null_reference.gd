extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var node = $NonExistentNode
	print("Node: %s" % node)
	
	if node:
		print("Node exists")
	else:
		# This will be executed
		print("Node doesn't exist")
	
	if node == null:
		# This will also be executed
		print("Node is null")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
