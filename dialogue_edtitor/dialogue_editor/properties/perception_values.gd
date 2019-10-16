extends GridContainer

export(PackedScene) var value_slider = preload("res://dialogue_editor/properties/value_slider.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for value in GAME_CONSTANTS._PERCEPTION_VALUES:
		var value_name = Label.new()
		value_name.text = value.capitalize()
		
		var slider = value_slider.instance()
		#slider.set_property_name(value)
		
		add_child(value_name)
		add_child(slider)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
