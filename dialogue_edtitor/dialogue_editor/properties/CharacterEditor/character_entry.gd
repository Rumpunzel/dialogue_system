extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func init(id:String):
	name = id
	$name.text = id


func _on_open_pressed():
	get_node("/root/main/editor/Characters").open_new_character($name.text)
