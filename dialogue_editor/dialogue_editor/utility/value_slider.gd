tool
extends HBoxContainer
class_name value_slider

export var min_value:float = -10
export var max_value:float = 10
export var step:float = 1

var value_name:String setget set_value_name, get_value_name

signal value_changed


func _ready():
	if get_property_value() == 0:
		set_property_value(1, null)
		update_value(0)
	
	setup_children()
	
	GAME_CONSTANTS.connect("values_changed", self, "setup_children")


func update_value(new_value, node_name = null, emit_signal = true):
	set_property_value(new_value, node_name)
	
	if emit_signal:
		emit_signal("value_changed", value_name, new_value)

func setup_children():
	for child in get_children():
		child.min_value = min_value
		child.max_value = max_value
		child.step = step


func set_property_value(new_value, node_name = null):
	for child in get_children():
		if not child.name == node_name:
			child.value = new_value

func set_value_name(new_name):
	value_name = new_name


func get_property_value():
	return $spin_box.value

func get_value_name() -> String:
	return value_name
