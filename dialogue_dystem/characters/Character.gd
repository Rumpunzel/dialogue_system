extends Node
class_name Character

class character_values:
	enum { POLITENESS, RELIABILITY, SELFLESSNESS, SINCERITY }
	
	var values
	
	func _init(politeness, reliability, selflessness, sincerity):
		values = [politeness, reliability, selflessness, sincerity]


#warning-ignore:unused_class_variable
export(float, -1, 1) var politeness
#warning-ignore:unused_class_variable
export(float, -1, 1) var reliability
#warning-ignore:unused_class_variable
export(float, -1, 1) var selflessness
#warning-ignore:unused_class_variable
export(float, -1, 1) var sincerity


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
