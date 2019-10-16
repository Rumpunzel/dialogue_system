extends Control
class_name perception_graph

export(NodePath) var subject_node = null
export(NodePath) var object_node = null

onready var subject = get_node(subject_node) if not subject_node == null else null
onready var object = get_node(object_node) if not object_node == null else null

var perception_names:Dictionary
var perception_values:Dictionary
var polygon_points:Array = []

var center


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	center = get_rect().size / 2
	
	for i in GAME_CONSTANTS._PERCEPTION_VALUES.size():
		var perception = GAME_CONSTANTS._PERCEPTION_VALUES[i]
		var perception_label = perception_names.get(perception)
		
		if perception_label == null:
			perception_label = Label.new()
			perception_names[perception] = perception_label
			add_child(perception_label)
			#perception_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
			#perception_label.grow_vertical = Control.GROW_DIRECTION_BOTH
		
		perception_label.text = perception.capitalize()
		
		var label_middle = perception_label.rect_size / 2
		perception_label.rect_pivot_offset = label_middle
		
		var new_rotation = (i / float(GAME_CONSTANTS._PERCEPTION_VALUES.size())) * TAU
		perception_label.rect_position = center + Vector2(0, -get_rect().size.y * 0.6).rotated(new_rotation) - label_middle
		perception_label.rect_rotation = int(rad2deg(new_rotation))
		
		var rot = abs(int(perception_label.rect_rotation) % 360)
		if rot > 90 and rot < 270:
			perception_label.rect_rotation += 180
	
	if not subject == null:
		perception_values = subject.personal_values
		if not object == null:
			var new_perceptions = subject.calculate_perception_value(subject.character_perceptions.get(object))
			update_perceptions_graph(new_perceptions)
	
	update()

func _draw():
	if not object == null:
		draw_colored_polygon(get_approval_rating_graph(), Color.maroon)
	
	draw_circle(get_rect().size / 2, get_rect().size.y / 4, Color.gray)
	
	draw_colored_polygon(get_graph(perception_values), Color.wheat)
	
	if not object == null and not polygon_points.empty():
		draw_colored_polygon(polygon_points, Color.cornflower)


func update_perceptions_graph(new_perceptions:Dictionary, manually_called = false):
	if manually_called:
		perception_values = new_perceptions
	
	polygon_points = get_graph(new_perceptions)

func get_graph(new_perceptions:Dictionary):
	var points = []
	
	for i in GAME_CONSTANTS._PERCEPTION_VALUES.size():
		var perception = GAME_CONSTANTS._PERCEPTION_VALUES[i]
		var new_rotation = (i / float(GAME_CONSTANTS._PERCEPTION_VALUES.size())) * TAU
		var new_point = center + Vector2(0, -get_rect().size.y / 4 * (1 + new_perceptions.get(perception, 0) / 10.0)).rotated(new_rotation)
		points.append(new_point)
	
	return points

func get_approval_rating_graph():
	var approval_rating = subject.calculate_approval_rating(object)
	
	return [Vector2(0, get_rect().size.y) * (1 - approval_rating / GAME_CONSTANTS._MAX_PERCEPTION_VALUE), Vector2(get_rect().size.x, get_rect().size.y  * (1 - approval_rating / GAME_CONSTANTS._MAX_PERCEPTION_VALUE)), Vector2(get_rect().size.x, get_rect().size.y), Vector2(0, get_rect().size.y)]
