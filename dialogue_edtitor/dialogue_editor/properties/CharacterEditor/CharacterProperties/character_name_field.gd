extends editor_name_field

var NPC:NPC


func set_NPC(new_NPC):
	NPC = new_NPC
	text = NPC.id

func connect_signals():
	editor_root.connect("current_NPC", self, "set_NPC")
