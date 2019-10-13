extends Control

var polygon_points = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_perceptions_graph(get_parent().calculate_perception_value(get_parent().character_perceptions.get(get_node("/root/main/Player"), { NPC.PERCEPTION_VALUES: { } })[ NPC.PERCEPTION_VALUES ]))

func _draw():
	draw_colored_polygon(get_approval_rating_graph(), Color.maroon)
	
	draw_circle(get_rect().size / 2, get_rect().size.y / 4, Color.gray)
	
	draw_colored_polygon(get_graph(get_parent().personal_values), Color.wheat)
	
	if not polygon_points.empty():
		draw_colored_polygon(polygon_points, Color.cornflower)


func update_perceptions_graph(new_perceptions):
	polygon_points = get_graph(new_perceptions)
	
	if not polygon_points.empty():
		update()

func get_graph(new_perceptions):
	var center = get_rect().size / 2
	var points_amount:float = new_perceptions.size()
	var points = []
	var value_index = 0
	
	for perception in new_perceptions.keys():
		var new_rotation = (value_index / float(points_amount)) * TAU
		var new_point = center + Vector2(0, -get_rect().size.y / 4 * (1 + new_perceptions[perception])).rotated(new_rotation)
		points.append(new_point)
		
#		var label = Label.new()
#		add_child(label)
#		label.grow_horizontal = Control.GROW_DIRECTION_BOTH
#		label.grow_vertical = Control.GROW_DIRECTION_BOTH
#		label.text = perception.capitalize()
#		label.rect_pivot_offset = label.rect_size / 2
#		label.rect_position = center + Vector2(0, -get_rect().size.y * 0.5).rotated(new_rotation)
#		label.rect_rotation = int(rad2deg(new_rotation))

		value_index += 1
	
	return points

func get_approval_rating_graph():
	var approval_rating = get_parent().calculate_approval_rating(get_node("/root/main/Player"))
	return [Vector2(0, get_rect().size.y) * (1 - approval_rating), Vector2(get_rect().size.x, get_rect().size.y  * (1 - approval_rating)), Vector2(get_rect().size.x, get_rect().size.y), Vector2(0, get_rect().size.y)]
