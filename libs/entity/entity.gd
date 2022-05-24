extends Node

# Name of this class
class_name Entity
# Instantiate itself
#var entity = Entity.new()

# Signals
signal has_attacked(damage)
signal hit_taken(damage)
signal life_changed(old_value, new_value)
signal life_depleted

# Properties
export(float) var damage:float = 1.00 setget set_damage, get_damage
export(String) var entity_name:String = "Entity" setget \
		set_entity_name, get_entity_name
# TODO: This should be double/float type
export(float) var life:float = 100 setget set_life, get_life

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Important Note for sets and gets
# Local access will not trigger the setter and getter
# Does not trigger setter/getter.
#print(my_integer)
# Does trigger setter/getter.
#print(self.my_integer)

### Functions ###
### Damage
func set_damage(value):
	damage = value
func get_damage():
	return damage

# Attack
func attack(target):
	target.hit(self.damage)
	emit_signal("has_attacked", self.damage)

### Entity name
func set_entity_name(value):
	entity_name = value
func get_entity_name():
	return entity_name

### Life
# Set and get
func set_life(value):
	var old_life = life
	life = value
	
	# Check if life is depleted
	life_depleted()
	
	emit_signal("life_changed", old_life, life)
func get_life():
	return life

# If the object was hit
func hit(value):
	self.life -= value
	emit_signal("hit_taken", value)

# Check if life is less than or equal to 0
func life_depleted():
	if self.life <= 0:
		print("Life depleted successfully")
		emit_signal("life_depleted")
		return true
	else: return false
