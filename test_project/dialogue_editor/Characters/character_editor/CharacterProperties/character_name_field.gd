extends editor_name_field

var NPC


func _ready():
	editor_root.connect("current_NPC", self, "set_NPC")


func set_NPC(new_NPC):
	NPC = new_NPC
	text = NPC.id
