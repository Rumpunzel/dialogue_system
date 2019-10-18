tool
extends value_slider


# Called when the node enters the scene tree for the first time.
func _ready():		
	update_value(GC.CONSTANTS[GC.PERCEPTION_VALUE_SLOPE])
	
	connect("value_changed", self, "update_PERCEPTION_VALUE_SLOPE")


func update_PERCEPTION_VALUE_SLOPE(_value_name, new_value):
	GC.CONSTANTS[GC.PERCEPTION_VALUE_SLOPE] = new_value
