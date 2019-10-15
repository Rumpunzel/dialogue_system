extends Button

var mode_map = { DRAW_DISABLED: "font_color_disabled", DRAW_NORMAL: "font_color", DRAW_HOVER: "font_color_hover", DRAW_PRESSED: "font_color_pressed" }

var active_theme:Theme

var current_mode

signal current_color

# Called when the node enters the scene tree for the first time.
func _ready():
	active_theme = get_active_theme()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not current_mode == get_draw_mode():
		current_mode = get_draw_mode()
		emit_signal("current_color", active_theme.get_color(mode_map[current_mode], "Button"))


func get_active_theme():
	var node_to_check = self
	var theme_found = theme
	
	while theme_found == null:
		node_to_check = node_to_check.get_parent()
		
		if node_to_check is Viewport:
			break
		
		theme_found = node_to_check.theme
	
	return theme_found
