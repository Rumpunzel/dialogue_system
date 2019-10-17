extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	GAME_CONSTANTS.connect("values_changed", self, "update_approvals")
	
	update_approvals()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_approvals():
	text = "Each Value can generate up to %0.2f Approval Rating to a total of:" % [(1 / float(GAME_CONSTANTS._PERCEPTION_VALUES.size())) * GAME_CONSTANTS._MAX_APPROVAL_VALUE]
