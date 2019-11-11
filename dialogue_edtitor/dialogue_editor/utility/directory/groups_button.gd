extends OptionButton

const ITEM_STRING = "Group by "

export(NodePath) var filter_field
export(NodePath) var tree


# Called when the node enters the scene tree for the first time.
func _ready():
	add_group(directory_tree.FOLDERS)
	
	
	add_group(directory_tree.NOTHING)
	
	connect("item_selected", self, "update_tree")
	get_node(filter_field).connect("text_confirmed", self, "update_filtered_tree")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func add_group(group_name):
	add_item("%s%s" % [ITEM_STRING, group_name])

func update_tree(id, filter = ""):
	get_node(tree).group_tree(get_item_text(id).trim_prefix(ITEM_STRING), filter)

func update_filtered_tree(filter):
	update_tree(selected, filter)
