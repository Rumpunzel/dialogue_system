extends MenuButton
class_name menu_option

enum { DELETE, UP, DOWN, MOVE, INSERT }


# Called when the node enters the scene tree for the first time.
func _ready():
	get_popup().add_item("Move Up", get_bit_flag([MOVE, UP]))
	get_popup().add_item("Move Down", get_bit_flag([MOVE, DOWN]))
	
	get_popup().add_separator()
	
	get_popup().add_item("Insert New Above", get_bit_flag([INSERT, UP]))
	get_popup().add_item("Insert New Below", get_bit_flag([INSERT, DOWN]))
	
	get_popup().add_separator()
	
	get_popup().add_item("Delete", get_bit_flag([DELETE]))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_bit_flag(values:Array) -> int:
	var bit_flag = 0
	
	for value in values:
		bit_flag += int(pow(2, value))
	
	return bit_flag
