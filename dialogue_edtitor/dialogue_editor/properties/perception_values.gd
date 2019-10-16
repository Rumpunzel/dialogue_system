extends GridContainer

export(PackedScene) var value_slider = preload("res://dialogue_editor/properties/value_slider.tscn")

export(NodePath) var perception_graph = null

var slider_values:Dictionary

signal update_perceptions_graph


# Called when the node enters the scene tree for the first time.
func _ready():
	if not perception_graph == null:
		connect("update_perceptions_graph", get_node(perception_graph), "update_perceptions_graph")
	
	for value in GAME_CONSTANTS._PERCEPTION_VALUES:
		var value_name = Label.new()
		value_name.text = value.capitalize()
		
		var slider = value_slider.instance()
		slider.value_name = value
		slider.connect("value_changed", self, "update_perceptions_graph")
		
		add_child(value_name)
		add_child(slider)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_perceptions_graph(value_name:String, new_value):
	slider_values[value_name] = new_value
	
	emit_signal("update_perceptions_graph", slider_values, true)
