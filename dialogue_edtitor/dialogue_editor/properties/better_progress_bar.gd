tool
extends ProgressBar
class_name BetterProgressBar

export var decimal_points = 1
#warning-ignore:unused_class_variable
export var percentage = true

onready var percentage_label = Label.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	if not percent_visible:
		add_child(percentage_label)
		percentage_label.align = Label.ALIGN_CENTER
		percentage_label.anchor_right = ANCHOR_END
		percentage_label.anchor_bottom = ANCHOR_END
		
		percentage_label.margin_left = 0
		percentage_label.margin_top = 0
		percentage_label.margin_right = 0
		percentage_label.margin_bottom = 0
		
		connect("value_changed", self, "update_percentage")
	
	update_percentage(value)
	
	GC.connect("values_changed", self, "update_max_value")


func update_percentage(new_value):
	percentage_label.text = ("%0." + str(decimal_points) + "f%s") % [new_value, "%" if percentage else ""]

func update_max_value():
	max_value = GC.CONSTANTS[GC.MAX_APPROVAL_VALUE]
