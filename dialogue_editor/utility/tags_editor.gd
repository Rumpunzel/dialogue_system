extends VBoxContainer

export(PackedScene) var tag_scene

export(String, FILE, "*.json") var tags_json


func _ready():
	var tags = json_helper.load_json(tags_json)
	
	if not tags == null:
		for tag in tags:
			var new_tag = tag_scene.instance()
			
			new_tag.setup_tree(tags[tag], tag)
			
			add_child(new_tag)
