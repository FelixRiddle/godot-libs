class_name InputHandler

var disable_wasd:bool = false setget set_disable_wasd, get_disable_wasd
var disable_arrows:bool = true setget set_disable_arrows, get_disable_arrows
var disable_joystick:bool = false setget set_disable_joystick, \
		get_disable_joystick


func _init(_options = {}):
	if(_options.get("disable_wasd")):
		self.disable_wasd = _options["disable_wasd"]
	if(_options.get("disable_arrows")):
		self.disable_arrows = _options["disable_arrows"]
	if(_options.get("disable_joystick")):
		self.disable_joystick = _options["disable_joystick"]
	if(_options.get("disable_joypad")):
		self.disable_joystick = _options["disable_joypad"]


### Player movement ###
# I've done this because its kinda annoying changing the project
# inputs every time we create a project
# Reference:
# https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-joysticklist
# Check if the player is moving left
func left(event) -> bool:
	# Keyboard
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_A and !self.disable_wasd:
				return true
			elif event.scancode == KEY_LEFT and !self.disable_arrows:
				return true
	
	# Joystick/Joypad
	#JOY_AXIS_0 = 0 --- Gamepad left stick horizontal axis.
	#JOY_AXIS_1 = 1 --- Gamepad left stick vertical axis.
	if(event is InputEventJoypadMotion and !self.disable_joystick):
		if event.axis == 0:
			# variable < 0 means the player is moving left
			# variable > 0 means the player is moving right
			# in a 2D world
			if event.axis_value < 0:
				return true
	return false


# Check if the player is moving right
func right(event) -> bool:
	# Keyboard
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_D and !self.disable_wasd:
				return true
			elif event.scancode == KEY_RIGHT and !self.disable_arrows:
				return true
	
	# Joystick/Joypad
	#JOY_AXIS_0 = 0 --- Gamepad left stick horizontal axis.
	#JOY_AXIS_1 = 1 --- Gamepad left stick vertical axis.
	if(event is InputEventJoypadMotion and !self.disable_joystick):
		if event.axis == 0:
			# variable < 0 means the player is moving left
			# variable > 0 means the player is moving right
			# in a 2D world
			if event.axis_value > 0:
				return true
	return false


# Check if the player is moving up
func up(event) -> bool:
	# Keyboard
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_W and !self.disable_wasd:
				return true
			elif event.scancode == KEY_UP and !self.disable_arrows:
				return true
	
	# Joystick/Joypad
	#JOY_AXIS_0 = 0 --- Gamepad left stick horizontal axis.
	#JOY_AXIS_1 = 1 --- Gamepad left stick vertical axis.
	if(event is InputEventJoypadMotion and !self.disable_joystick):
		if event.axis == 1:
			# variable < 0 means the player is moving down
			# variable > 0 means the player is moving up
			# in a 2D world
			if event.axis_value > 0:
				return true
	return false


# Check if the player is moving down
func down(event) -> bool:
	# Keyboard
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_S and !self.disable_wasd:
				return true
			elif event.scancode == KEY_DOWN and !self.disable_arrows:
				return true
	
	# Joystick/Joypad
	#JOY_AXIS_0 = 0 --- Gamepad left stick horizontal axis.
	#JOY_AXIS_1 = 1 --- Gamepad left stick vertical axis.
	if(event is InputEventJoypadMotion and !self.disable_joystick):
		if event.axis == 1:
			# variable < 0 means the player is moving down
			# variable > 0 means the player is moving up
			# in a 2D world
			if event.axis_value < 0:
				return true
	return false


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
