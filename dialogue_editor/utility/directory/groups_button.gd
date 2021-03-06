extends OptionButton

const ITEM_STRING = "Group by "

export(NodePath) var filter_field
export(NodePath) var tree_node

onready var tree = get_node(tree_node)

var groups:Array


# Called when the node enters the scene tree for the first time.
func _ready():
	setup_groups()
	
	connect("item_selected", self, "update_tree")
	get_node(filter_field).connect("text_confirmed", self, "update_filtered_tree")
	
	tree.connect("tree_parsed", self, "setup_groups")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func add_group(group_name):
	add_item(group_name.capitalize())

func update_tree(id, filter = ""):
	var item = get_item_text(id)
	tree.group_tree(item.to_lower(), filter)
	
	selected = id
	text = "%s%s" % [ITEM_STRING, item]

func update_filtered_tree(filter):
	update_tree(selected, filter)

func setup_groups():
	clear()
	add_group(DirectoryTree.FOLDERS)
	add_group(DirectoryTree.NOTHING)
	
	groups = tree.groups
	groups.sort()
	
	for grp in groups:
		add_group(grp)
	
	text = "%s%s" % [ITEM_STRING, DirectoryTree.FOLDERS.capitalize()]
