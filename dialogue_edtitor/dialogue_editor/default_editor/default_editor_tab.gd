extends VBoxContainer
class_name default_editor_tab

export(NodePath) var save_button
export(NodePath) var close_button
export(NodePath) var delete_button

export(NodePath) var name_field

var json_path:String setget set_json_path, get_json_path

var json:Dictionary

signal new_json



# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(save_button).connect("pressed", self, "save_changes")
	get_node(close_button).connect("confirmed", self, "close_tab")
	get_node(delete_button).connect("confirmed", self, "delete_entry")



func setup(id:String, json_path:String):
	set_json_path(json_path)
	
	set_tab_id(id)


func save_changes():
	var new_path = "%s%s" % [json_path.get_base_dir().plus_file(name), get_parent().get_file_extension()]
	json_helper.save_json(json, new_path)
	
	if not new_path == json_path:
		file_helper.delete_file(json_path)
		json_path = new_path
	
	if CONSTANTS.verbose_mode:
		CONSTANTS.print_to_console("%s changes saved." % [name])


func close_tab(save_changes = true):
	if save_changes:
		save_changes()
	
	queue_free()


func delete_entry(path = json_path, new_path = null):
	if not new_path == null:
		json_helper.save_json(json, new_path)
	
	file_helper.delete_file(path)
	
	if CONSTANTS.verbose_mode:
		CONSTANTS.print_to_console("%s deleted." % [name])
	
	if path == json_path:
		close_tab(false)


func tab_exists(path:String):
	return path == json_path



func set_tab_id(new_id:String):
	if not new_id == "":
		name = new_id
	
	get_node(name_field).text = name


func set_json_path(new_path:String):
	json_path = new_path
	
	var new_json = json_helper.load_json(json_path)
	
	if not new_json == null:
		json = new_json
		
		emit_signal("new_json", json)



func get_json_path() -> String:
	return json_path
