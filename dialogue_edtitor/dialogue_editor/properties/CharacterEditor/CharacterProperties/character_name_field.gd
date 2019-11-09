extends editor_name_field

var NPC:NPC


# Called when the node enters the scene tree for the first time.
func _ready():
	editor_root.connect("current_NPC", self, "set_NPC")


func set_NPC(new_NPC):
	NPC = new_NPC
	text = NPC.id