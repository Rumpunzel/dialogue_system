extends default_editor_tab
class_name character_editor

export(NodePath) var portrait
export(NodePath) var bio

onready var NPC:NPC = $NPC

signal current_NPC



# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(portrait).connect("new_portrait", NPC, "set_portrait_path")
	get_node(bio).connect("new_bio", NPC, "set_bio")



func setup(id:String, json_path:String):
	.setup(id, json_path)
	
	get_node(portrait).set_portrait(NPC.portrait_path, true)
	get_node(bio).set_bio(NPC.bio)


func save_changes():
	var new_path = "%s%s" % [json_path.get_base_dir().plus_file(name), get_parent().get_file_extension()]
	NPC.json_path = new_path
	
	NPC.store_values()
	
	if not new_path == json_path:
		file_helper.delete_file(json_path)
		json_path = new_path
	
	if CONSTANTS.verbose_mode:
		CONSTANTS.print_to_console("%s changes saved." % [name])


func set_json_path(new_path:String):
	.set_json_path(new_path)
	
	NPC.json_path = new_path


func set_tab_id(new_id:String):
	.set_tab_id(new_id)
	
	NPC.id = new_id
	
	if not new_id == "":
		NPC.load_values()
	
	emit_signal("current_NPC", NPC)



func get_directory_path():
	return Character.json_paths[Character.STATS_PATHS.MODIFIED]
