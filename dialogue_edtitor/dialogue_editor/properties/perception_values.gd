extends GridContainer

enum { VALUE_NAME, SLIDER }

export(PackedScene) var value_slider = preload("res://dialogue_editor/properties/value_slider.tscn")

export(NodePath) var NPC_node

onready var NPC:NPC = get_node(NPC_node)

var perception_entries:Array
var slider_values:Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	GC.connect("values_changed", self, "update_perception_entries")
	
	update_perception_entries()


func update_perceptions_graph(value_name:String, new_value):
	if value_name.length() > 0:
		slider_values[value_name] = new_value
		
		NPC.personal_values = slider_values

func update_perception_entries():
	var new_perception_values = GC.CONSTANTS[GC.PERCEPTION_VALUES]
	
	for i in max(perception_entries.size(), new_perception_values.size()):
		if i < new_perception_values.size():
			var perception = new_perception_values[i]
			
			if i >= perception_entries.size():
				var value_name = Label.new()
				var slider = value_slider.instance()
				
				slider.connect("value_changed", self, "update_perceptions_graph")
				
				perception_entries.append([value_name, slider])
				
				add_child(value_name)
				add_child(slider)
			
			perception_entries[i][VALUE_NAME].text = perception.capitalize()
			perception_entries[i][VALUE_NAME].name = "%s_%s" % [perception, "label"]
			perception_entries[i][SLIDER].value_name = perception
			perception_entries[i][SLIDER].name = "%s_%s" % [perception, "slider"]
			
			if slider_values.has(perception):
				perception_entries[i][SLIDER].update_value(slider_values[perception])
		else:
			for stuff in perception_entries[i]:
				stuff.queue_free()
	
	perception_entries.resize(new_perception_values.size())
