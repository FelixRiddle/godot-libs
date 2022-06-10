extends Control

onready var arc = $Panel/AspectRatioContainer
onready var panel = $Panel

var base_window_size = Vector2(
		ProjectSettings.get_setting("display/window/size/width"),
		ProjectSettings.get_setting("display/window/size/height"))
var gui_aspect_ratio = -1.0
var gui_margin = 0.0
var scale_factor = 1.0
var stretch_mode = SceneTree.STRETCH_MODE_2D
var stretch_aspect = SceneTree.STRETCH_ASPECT_EXPAND

func _ready():
	# Resolutions
	var resolution_option_button:OptionButton = \
			$Panel/AspectRatioContainer/GraphicSettings/Resolution/OptionButton
	var resolutions = ["648x648 (1:1)", "640x480 (4:3)", "720x480 (3:2)",
			"800x600 (4:3)", "1152x648 (16:9)", "1280x720 (16:9)",
			"1280x800 (16:10)", "1680x720 (21:9)"]
	for resolution in resolutions:
		resolution_option_button.add_item(resolution)
	
	# Aspect ratios
	var gui_aspect_ratio_option_button:OptionButton = \
			$Panel/AspectRatioContainer/GraphicSettings/GUIAspectRatio/OptionButton
	var aspect_ratios = ["Fit to window", "5:4", "4:3", "3:2", "16:10", "16:9",
			"21:9"]
	for aspect_ratio in aspect_ratios:
		gui_aspect_ratio_option_button.add_item(aspect_ratio)
	
	connect("resized", self, "_on_resized")
	update_container()


func update_container():
	# The code within this function needs to be run twice to work around an issue with containers
	# having a 1-frame delay with updates.
	# Otherwise, `panel.rect_size` returns a value of the previous frame, which results in incorrect
	# sizing of the inner AspectRatioContainer when using the Fit to Window setting.
	for _i in 2:
		if is_equal_approx(gui_aspect_ratio, -1.0):
			# Fit to Window. Tell the AspectRatioContainer to use the same aspect ratio as the window,
			# making the AspectRatioContainer not have any visible effect.
			arc.ratio = panel.rect_size.aspect()
			# Apply GUI margin on the AspectRatioContainer's parent (Panel).
			# This also makes the GUI margin apply on controls located outside the AspectRatioContainer
			# (such as the inner side label in this demo).
			panel.margin_top = gui_margin
			panel.margin_bottom = -gui_margin
		else:
			# Constrained aspect ratio.
			arc.ratio = min(panel.rect_size.aspect(), gui_aspect_ratio)
			# Adjust top and bottom margins relative to the aspect ratio when it's constrained.
			# This ensures that GUI margin settings behave exactly as if the window had the
			# original aspect ratio size.
			panel.margin_top = gui_margin / gui_aspect_ratio
			panel.margin_bottom = -gui_margin / gui_aspect_ratio

		panel.margin_left = gui_margin
		panel.margin_right = -gui_margin


func _on_GUIAspectRatio_item_selected(index):
	match index:
		0:  # Fit to Window
			gui_aspect_ratio = -1.0
		1:  # 5:4
			gui_aspect_ratio = 5.0 / 4.0
		2:  # 4:3
			gui_aspect_ratio = 4.0 / 3.0
		3:  # 3:2
			gui_aspect_ratio = 3.0 / 2.0
		4:  # 16:10
			gui_aspect_ratio = 16.0 / 10.0
		5:  # 16:9
			gui_aspect_ratio = 16.0 / 9.0
		6:  # 21:9
			gui_aspect_ratio = 21.0 / 9.0

	update_container()


func _on_OptionButton_item_selected(index):
	match index:
		0:  # 648×648 (1:1)
			base_window_size = Vector2(648, 648)
		1:  # 640×480 (4:3)
			base_window_size = Vector2(640, 480)
		2:  # 720×480 (3:2)
			base_window_size = Vector2(720, 480)
		3:  # 800×600 (4:3)
			base_window_size = Vector2(800, 600)
		4:  # 1152×648 (16:9)
			base_window_size = Vector2(1152, 648)
		5:  # 1280×720 (16:9)
			base_window_size = Vector2(1280, 720)
		6:  # 1280×800 (16:10)
			base_window_size = Vector2(1280, 800)
		7:  # 1680×720 (21:9)
			base_window_size = Vector2(1680, 720)

	get_tree().set_screen_stretch(
			stretch_mode,
			stretch_aspect,
			base_window_size,
			scale_factor)
	update_container()


func _on_resized():
	update_container()


func _on_VSync_toggled(button_pressed):
	OS.vsync_enabled = !OS.vsync_enabled
