var enable:bool = false setget _set_enable, _get_enable
var obj setget _set_obj, _get_obj
var opacity_low:float = .4 setget set_opacity_low, get_opacity_low
var opacity_high:float = 1.0 setget set_opacity_high, get_opacity_high

# I consider functions/methods that start with _, private functions/methods
func _set_enable(value) -> void:
	enable = value
func _get_enable() -> bool:
	return enable


func _set_obj(value) -> void:
	obj = value
func _get_obj():
	return obj


func _auto_detect_areas(obj_ref) -> bool:
	# Opacity area
	var opacity_area = obj_ref.find_node("OpacityArea")
	if(opacity_area is Area2D):
		opacity_area.connect("body_entered", self,
				"_on_OpacityArea_body_entered")
		opacity_area.connect("body_exited", self,
				"_on_OpacityArea_body_entered")
		return true
	return false


# Object reference
func enable(obj_ref) -> bool:
	if(obj_ref is Node):
		self.obj = obj_ref
		return _auto_detect_areas(obj_ref)
	
	return false


func set_opacity_low(value) -> void:
	opacity_low = value
func get_opacity_low() -> float:
	return opacity_low


func set_opacity_high(value) -> void:
	opacity_high = value
func get_opacity_high() -> float:
	return opacity_high


func _on_OpacityArea_body_entered(body):
	if(body.name == "Player"):
		obj.modulate.a = self.opacity_low


func _on_OpacityArea_body_exited(body):
	if(body.name == "Player"):
		obj.modulate.a = self.opacity_high
