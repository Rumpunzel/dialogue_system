extends BetterLineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	text = "%d" % [GAME_CONSTANTS._MAX_APPROVAL_VALUE]
	
	connect("text_confirmed", GAME_CONSTANTS, "set_MAX_APPROVAL_VALUE")
