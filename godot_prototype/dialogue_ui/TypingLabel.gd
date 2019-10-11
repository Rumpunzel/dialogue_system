extends RichTextLabel
class_name TypingLabel

export var typing_speed:float = 50

export(Color) var highlight_color = Color("830303")
export(String) var start_highlight_markdown = "<"
export(String) var end_highlight_markdown = ">"

export var type_on_start = true

var visible_counter:float


func _ready():
	if type_on_start:
		type_text(text)
	else:
		parse_markdown(text)
		visible_counter = text.length()

func _process(delta):
	visible_counter += delta * typing_speed
	visible_counter = min(text.length(), visible_counter)
	visible_characters = int(visible_counter)

func _input(event):
	if event is InputEventMouseButton:
		visible_counter = text.length()

func type_text(new_text):
	parse_markdown(new_text)
	visible_counter = 0

func parse_markdown(parse_text:String):
	parse_text = parse_text.replace(start_highlight_markdown, "[color=#" + highlight_color.to_html() + "]")
	parse_text = parse_text.replace(end_highlight_markdown, "[/color]")
	
	parse_bbcode(parse_text)
