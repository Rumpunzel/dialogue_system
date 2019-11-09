extends GridContainer

enum { VALUE_NAME, SLIDER }

export(PackedScene) var value_slider

export(NodePath) var root_node

onready var editor_root:character_editor = get_node(root_node).root_node

var perception_entries:Array = []
var NPC:NPC = null


# Called when the node enters the scene tree for the first time.
func _ready():
	update_perception_entries()
	
	GAME_CONSTANTS.connect("values_changed", self, "update_perception_entries")
	editor_root.connect("current_NPC", self, "set_NPC")


func update_perceptions_graph(value_name:String, new_value):
	if value_name.length() > 0:
		NPC.personal_values[value_name] = new_value

func update_perception_entries():
	var new_perception_values = GAME_CONSTANTS.PERCEPTION_VALUES
	
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
			
			if not NPC == null and NPC.personal_values.has(perception):
				perception_entries[i][SLIDER].update_value(NPC.personal_values[perception])
		else:
			for stuff in perception_entries[i]:
				stuff.queue_free()
	
	perception_entries.resize(new_perception_values.size())

func update_perception_values(new_values):
	var perception_values = GAME_CONSTANTS.PERCEPTION_VALUES
	
	for i in perception_values.size():
		var perception = perception_values[i]

		if NPC.personal_values.has(perception):
			perception_entries[i][SLIDER].update_value(new_values[perception], null, false)

func set_NPC(new_NPC):
	NPC = new_NPC
	
	update_perception_values(NPC.personal_values)
	
	#NPC.connect("values_changed", self, "update_perception_values")
