class_name BinarySearchTree

var root = null setget set_root, get_root

func _init():
	pass

### Methods/Functions ###
# Reference: https://geeksforgeeks.org
### Insert method
# Helper method which creates a new node to
# be inserted and calls insertNode
func insert(data):
	# Creating a node and initializing it with data
	var new_node = BSTNode.new(data)
	
	# Root is null then node will be added to the tree and made root
	if(self.root == null):
		self.root = new_node
	else:
		# Find the correct position in the tree and add the node
		insert_node(self.root, new_node)

### Insert method
# Method to insert a node in a tree, it moves over the tree to find the
# location to insert a node with a given data
func insert_node(node, new_node):
	# If the data is less than the node data moves left of the tree
	if(new_node.data < node.data):
		# If left is null insert node here
		if(node.left == null):
			node.left = new_node
		else:
			# If left is not null recur until null is found
			insert_node(node.left, new_node)
	else: # If the data is more than the node, data moves right of the tree
		# If right is null, insert node here
		if(node.right == null):
			node.right = new_node
		else:
			# If right is not null recur until null is found
			insert_node(node.right, new_node)

### Remove
# Remove a node with a given data
func remove(data):
	# Root is re-initialized with root of a modified tree.
	self.root = remove_node(self.root, data)

# Method to remove a node with a given data, it recurs over the tree to find
# the data and removes it
func remove_node(node, key):
	# If the root is null then tree is empty
	if(node == null):
		return null
		
		# If data to be deleted is less than roots data then move to the left
		# subtree
	elif(key < node.data):
		node.left = remove_node(node.left, key)
		return node
		
		# If data to be deleted is greater than roots data then move to the
		# right subtree
	elif(key > node.data):
		node.right = remove_node(node.right, key)
		return node
		
		# If data is similar to the root's data then delete this node
	else:
		# Deleting node with no children
		if(node.left == null && node.right == null):
			node = null
			return node
		
		# Deleting node with one children
		if(node.left == null):
			node = node.right
			return node
		elif(node.right == null):
			node = node.left
			return node
		
		# Deleting node with two children minimum node of the right subtree
		# is stored in aux
		var aux = self.find_minimum_node(node.right)
		node.data = aux.data
		
		node.right = remove_node(node.right, aux.data)
		return node

### Debug
# Performs in order traversal of a tree
func print_in_order(node):
	if(node != null):
		print_in_order(node.left)
		print(node.data)
		print_in_order(node.right)

# Performs preorder traversal of a tree
func print_preorder(node):
	if(node != null):
		print(node.data)
		print_preorder(node.data)
		print_preorder(node.right)

# Performs postorder traversal of a tree
func print_postorder(node):
	if(node != null):
		print_postorder(node.left)
		print_postorder(node.right)
		print(node.data)

### Find minimum node
# Finds the minimum node in tree searching, starts from given node
func find_minimum_node(node):
	# If the left side of a node is null then it must be minimum node
	if(node.left == null):
		return node
	else:
		return find_minimum_node(node.left)

### Search
# Search for a node with a given data
func search(node, data):
	# If trees is empty return null
	if(node == null):
		return null
		
		# If data is less than node's data, move left
	elif(data < node.data):
		return search(node.left, data)
		
		# If data is greater than node's data, move right
	elif(data > node.data):
		return search(node.right, data)
		
		# if data is equal to the node data, return the node
	else: return node

# Find, the same as search
func find(node, data):
	return search(node, data)

### Root
func set_root(value):
	root = value
func get_root():
	return root

### Nodes for the binary search tree
class BSTNode:
	var data = null setget set_data, get_data
	var left = null setget set_left, get_left
	var right = null setget set_right, get_right

	func _init(dataA):
		self.data = dataA
		self.left = null
		self.right = null

	### Methods/Functions ###
	### Data
	func set_data(value):
		data = value
	func get_data():
		return data

	### Left
	func set_left(value):
		left = value
	func get_left():
		return left

	### Right
	func set_right(value):
		right = value
	func get_right():
		return right
