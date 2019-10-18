tool
extends value_slider


# Called when the node enters the scene tree for the first time.
func _ready():
	update_value(GC.CONSTANTS[GC.PECERPTION_VALUE_GROWTH_POINT])
	
	connect("value_changed", self, "update_PERCEPTION_VALUE_GROWTH_POINT")


func update_PERCEPTION_VALUE_GROWTH_POINT(_value_name, new_value):
	GC.CONSTANTS[GC.PECERPTION_VALUE_GROWTH_POINT] = new_value

func setup_children():
	max_value = GC.CONSTANTS[GC.MAX_PERCEPTION_VALUE] * 2
	.setup_children()
