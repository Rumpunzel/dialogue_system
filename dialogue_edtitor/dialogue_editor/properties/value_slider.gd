extends HBoxContainer

var value_name:String setget set_value_name, get_value_name

signal value_changed


func update_value(new_value, node_name = null):
	set_property_value(new_value, node_name)
	emit_signal("value_changed", value_name, new_value)


func set_property_value(new_value:int, node_name = null):
	for child in get_children():
		if not child.name == node_name:
			child.value = new_value

func set_value_name(new_name):
	value_name = new_name


func get_property_value() -> int:
	return $spin_box.value

func get_value_name() -> String:
	return value_name
