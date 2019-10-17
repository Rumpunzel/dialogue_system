extends value_slider


# Called when the node enters the scene tree for the first time.
func _ready():	
	connect("value_changed", self, "update_PERCEPTION_VALUE_SLOPE")
	
	update_value(GAME_CONSTANTS._PERCEPTION_VALUE_SLOPE)


func update_PERCEPTION_VALUE_SLOPE(_value_name, new_value):
	GAME_CONSTANTS._PERCEPTION_VALUE_SLOPE = new_value
