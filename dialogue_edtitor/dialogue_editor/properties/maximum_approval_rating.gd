extends BetterLineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	text = "%d" % [GAME_CONSTANTS.MAX_APPROVAL_VALUE]
	
	connect("text_confirmed", self, "update_max_approval_value")


func update_max_approval_value(new_value):
	GAME_CONSTANTS.MAX_APPROVAL_VALUE = int(new_value)
