extends VBoxContainer
class_name default_editor_tab

export(NodePath) var save_button
export(NodePath) var close_button
export(NodePath) var delete_button

var tab_id:String setget set_tab_id, get_tab_id
var old_id:String

signal new_id


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(save_button).connect("pressed", self, "save_changes")
	get_node(close_button).connect("confirmed", self, "close_tab")
	get_node(delete_button).connect("confirmed", self, "delete_character")


func setup(id:String):
	set_tab_id(id)
	
	old_id = id

func save_changes():
	if not old_id == tab_id:
		delete_entry(old_id, tab_id)
		old_id = tab_id
	
	if CONSTANTS.verbose_mode:
		CONSTANTS.print_to_console("%s changes saved." % [tab_id])

func close_tab(save_changes = true):
	if save_changes:
		save_changes()
	
	queue_free()

func delete_entry(id, new_id = null):
	var json_path = get_json_path()
	
	var loaded_json = json_helper.load_json(json_path)
	
	if not new_id == null:
		loaded_json[new_id] = loaded_json.get(id, { })
	
	loaded_json.erase(id)
	
	json_helper.save_json(loaded_json, json_path)
	
	if CONSTANTS.verbose_mode:
		CONSTANTS.print_to_console("%s deleted." % [id])
	
	if id == tab_id:
		close_tab(false)

func tab_exists(id:String):
	var json_path = get_json_path()
	var loaded_json = json_helper.load_json(json_path)
	
	for tab in loaded_json.keys():
		if tab == id:
			return true
	
	return false


func set_tab_id(new_id:String):
	tab_id = new_id
	
	if not tab_id == "":
		name = tab_id
	
	emit_signal("new_id", name)


func get_tab_id() -> String:
	return tab_id

func get_json_path():
	return ""
