class_name InputHandler

var deadzone:float = 0.10 setget set_deadzone, get_deadzone
var disable_wasd:bool = false setget set_disable_wasd, get_disable_wasd
var disable_arrows:bool = true setget set_disable_arrows, get_disable_arrows
var disable_joystick:bool = false setget set_disable_joystick, \
		get_disable_joystick


func _init(_options = { }) -> void:
	if(_options.has("disable_wasd")):
		self.disable_wasd = _options["disable_wasd"]
	if(_options.has("disable_arrows")):
		self.disable_arrows = _options["disable_arrows"]
	if(_options.has("disable_joystick")):
		self.disable_joystick = _options["disable_joystick"]
	if(_options.has("disable_joypad")):
		self.disable_joystick = _options["disable_joypad"]
	if(_options.has("deadzone")):
		self.deadzone = _options["deadzone"]


### Player movement ###
# Personal notes for using Input.get_joy_axis(device, axis):
# The first argument(device), I guess it's that if there are
# more than one device connected to the same computer, they are
# listed with an index starting from 0.
# For the second argument use one of the following
#JOY_AXIS_0 = 0 --- Gamepad left stick horizontal axis.
#JOY_AXIS_1 = 1 --- Gamepad left stick vertical axis.
# Up is -1 for gamepads for some reason(tested with an old one)
# Check if the player is moving left
func left() -> bool:
	if(Input.is_physical_key_pressed(KEY_A) && !self.disable_wasd):
		return true
	if(Input.is_physical_key_pressed(KEY_LEFT) && !self.disable_arrows):
		return true
	
	# The minus is very important xD
	if(Input.get_joy_axis(0, 0) < -self.deadzone && !self.disable_joystick):
		return true
	return false


# Check if the player is moving right
func right() -> bool:
	if(Input.is_physical_key_pressed(KEY_D) && !self.disable_wasd):
		return true
	if(Input.is_physical_key_pressed(KEY_RIGHT) && !self.disable_arrows):
		return true
	
	if(Input.get_joy_axis(0, 0) > self.deadzone && !self.disable_joystick):
		return true
	return false


# Check if the player is moving up
func up() -> bool:
	if(Input.is_physical_key_pressed(KEY_W) && !self.disable_wasd):
		return true
	if(Input.is_physical_key_pressed(KEY_UP) && !self.disable_arrows):
		return true
	
	# The minus is very important xD
	if(Input.get_joy_axis(0, 1) < -self.deadzone && !self.disable_joystick):
		return true
	return false


# Check if the player is moving up
func down() -> bool:
	if(Input.is_physical_key_pressed(KEY_S) && !self.disable_wasd):
		return true
	if(Input.is_physical_key_pressed(KEY_DOWN) && !self.disable_arrows):
		return true
	
	if(Input.get_joy_axis(0, 1) > self.deadzone && !self.disable_joystick):
		return true
	return false

# Setget deadzone
func set_deadzone(value:float) -> void:
	deadzone = value
func get_deadzone() -> float:
	return deadzone

# Setget disable_wasd
func set_disable_wasd(value:bool) -> void:
	disable_wasd = value
func get_disable_wasd() -> bool:
	return disable_wasd


# Setget disable_arrows
func set_disable_arrows(value:bool) -> void:
	disable_arrows = value
func get_disable_arrows() -> bool:
	return disable_arrows


# Setget disable_joystick
func set_disable_joystick(value:bool) -> void:
	disable_joystick = value
func get_disable_joystick() -> bool:
	return disable_joystick
