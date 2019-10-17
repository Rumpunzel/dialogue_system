extends value_slider


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("value_changed", self, "update_PERCEPTION_VALUE_GROWTH_POINT")
	
	update_value(GAME_CONSTANTS._PECERPTION_VALUE_GROWTH_POINT)


func update_PERCEPTION_VALUE_GROWTH_POINT(_value_name, new_value):
	GAME_CONSTANTS._PECERPTION_VALUE_GROWTH_POINT = new_value

func setup_children():
	max_value = GAME_CONSTANTS._MAX_PERCEPTION_VALUE * 2
	.setup_children()
