extends Control
class_name perception_graph

# The NPC evaluating in this comparison
export(NodePath) var subject_node = null
# The character being evaluated by the subject
# Most of the time this will be the player but this also works with other NPCs
export(NodePath) var object_node = null

# Convert the node paths to actual node references
onready var subject:NPC = get_node(subject_node) if not subject_node == null else null
onready var object:Character = get_node(object_node) if not object_node == null else null

# Used for proper placement of the graph
onready var center = get_rect().size / 2
onready var radius = min(get_rect().size.y / 2, get_rect().size.x / 2)

# Array of the name of the perception values
var perception_names:Array = []

# Dictionary of the actual values
var perception_values:Dictionary
# Array of the polygon points drawn on the graph of the NPC's values
var polygon_points:Array = []


func _ready():
	# This is mostly used in the editor to update the graphs after editing perception values
	GAME_CONSTANTS.connect("values_changed", self, "update_perception_values")
	
	update_perception_values()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	center = get_rect().size / 2
	radius = min(get_rect().size.x / 2, get_rect().size.y / 2)
	
	update_perception_values()
	
	if not subject == null:
		perception_values = subject.personal_values

		if not object == null:
			var new_perceptions = subject.character_perceptions.get(object.id, { }).get(NPC.PERCEPTION_VALUES, { })
			
			update_perceptions_graph(new_perceptions)
	
	update()

# Draw the polygons on the graph
func _draw():
	# A red bar in the background of the graph displaying the approval rating of the subject towards the object
	if not object == null:
		draw_colored_polygon(get_approval_rating_graph(), Color.maroon)
	
	# Just some helper lines
	for i in perception_names.size():
		draw_line(center, center + Vector2(0, -radius).rotated((i / float(perception_names.size()) * TAU)), Color.black)
	
	# Get the subject's values
	var graph_points = get_graph(perception_values) if not subject == null else []
	
	# Check if the resulting polygon for the subject is valid
	if math_helper.get_unique_values_in_array(graph_points, 0.1) >= 3:
		draw_colored_polygon(graph_points, Color.cornflower)
		
		# Check if the resulting polygon for the object is valid
		if not object == null and not polygon_points.empty() and math_helper.get_unique_values_in_array(polygon_points, 0.1) >= 3:
			var per_color = Color.wheat
			per_color.a = 0.7
			draw_colored_polygon(polygon_points, per_color)
	
	# Draw more helper lines to make it look a little nicer
	for i in perception_names.size():
		draw_line(center + Vector2(0, -radius / 2).rotated((i / float(perception_names.size()) * TAU)), center + Vector2(0, -radius / 2).rotated(((i + 1) / float(perception_names.size()) * TAU)), Color.black)
	
	for i in perception_names.size():
		draw_line(center + Vector2(0, -radius).rotated((i / float(perception_names.size()) * TAU)), center + Vector2(0, -radius).rotated(((i + 1) / float(perception_names.size()) * TAU)), Color.black)
	
	draw_empty_circle(center, radius, Color.black, 10)


func update_perception_values():
	var new_perception_values = GAME_CONSTANTS.PERCEPTION_VALUES
	
	for i in max(perception_names.size(), new_perception_values.size()):
		if i < new_perception_values.size():
			var perception_label
			
			if i < perception_names.size():
				perception_label = perception_names[i]
			else:
				perception_label = Label.new()
				perception_label.align = Label.ALIGN_CENTER
				perception_names.append(perception_label)
				add_child(perception_label)
			
			perception_label.text = new_perception_values[i].capitalize()
			
			var new_rotation =  modified_rotation(i)
			var label_middle = Vector2(perception_label.get_rect().size.x * (0.5 - 0.5 * sin(new_rotation)), perception_label.get_rect().size.y * 0.5)
			
			perception_label.rect_pivot_offset = label_middle
			perception_label.rect_position = center + Vector2(0, -radius - 20).rotated(new_rotation) - label_middle
		else:
			perception_names[i].queue_free()
	
	perception_names.resize(new_perception_values.size())

func update_perceptions_graph(new_perceptions:Dictionary):
	polygon_points = get_graph(new_perceptions)

func get_graph(new_perceptions:Dictionary):
	new_perceptions = subject.calculate_perception_value(new_perceptions)
	var points = []
	var values = GAME_CONSTANTS.PERCEPTION_VALUES
	points.resize(values.size())
	
	if not radius == null and not center == null:
		for i in values.size():
			var perception = values[i]
			var new_rotation = modified_rotation(i)
			var new_point = center + Vector2(0, -radius / 2 * (1 + new_perceptions.get(perception, 0))).rotated(new_rotation)
			
			points[(int(get_modified_index(i)) + points.size()) % points.size()] = new_point
	
	return points

func get_approval_rating_graph():
	var approval_rating = subject.calculate_approval_rating(object.id)
	var approval_ratio = (get_rect().size.y / 2) *  (1 - approval_rating / GAME_CONSTANTS.MAX_APPROVAL_VALUE)
	
	return [Vector2(0, approval_ratio), Vector2(get_rect().size.x, approval_ratio), Vector2(get_rect().size.x, get_rect().size.y / 2), Vector2(0, get_rect().size.y / 2)]

func modified_rotation(index):
	var value_size = GAME_CONSTANTS.PERCEPTION_VALUES.size()
	var modified_index = get_modified_index(index)
	
	return (modified_index / float(value_size)) * TAU

# Orders the perception values from top to bottom and then left to right instead of clockwise around the graph
func get_modified_index(index):
	return ceil(index / 2.0) * (1 if index % 2 == 0 else -1)

func draw_empty_circle(circle_center:Vector2, circle_radius, color:Color, resolution:float):
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	circle_radius = Vector2(0, circle_radius)
	line_origin = circle_radius + circle_center
	
	while draw_counter <= 360:
		line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color)
		draw_counter += 1 / resolution
		line_origin = line_end
	
	line_end = circle_radius.rotated(deg2rad(360)) + circle_center
	draw_line(line_origin, line_end, color)
