extends HBoxContainer

func set_property_value(new_value:int):
	$spin_box.value = new_value

func get_property_value() -> int:
	return $spin_box.value
