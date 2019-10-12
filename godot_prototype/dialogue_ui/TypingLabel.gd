extends RichTextLabel
class_name TypingLabel

const SENTENCE_ENDS = [".", "?", "!", ":"]
const PUNCTUATIONS = [",", ";"]

export var typing_speed:float = 50
export var pause_on_sentence_end:float = 0.3
export var pause_on_comma:float = 0.2

export(Color) var highlight_color = Color("830303")
export(String) var start_highlight_markdown = "<"
export(String) var end_highlight_markdown = ">"

export var type_first_message = true

onready var punctuation_timer = Timer.new()

var visible_counter:float
var currently_counting = true
var typing = true


func _ready():
	add_child(punctuation_timer)
	punctuation_timer.one_shot = false
	punctuation_timer.connect("timeout", self, "continue_counting")
	
	if type_first_message:
		type_text(text)
	else:
		parse_markdown(text)
		visible_counter = text.length()

func _process(delta):
	if currently_counting and typing:
		visible_counter += delta * typing_speed
		visible_counter = min(text.length(), visible_counter)
		visible_characters = int(visible_counter)
		
		var current_character = text[max(0, visible_characters - 1)]
		
		if current_character in SENTENCE_ENDS:
			currently_counting = false
			punctuation_timer.start(pause_on_sentence_end)
		elif current_character in PUNCTUATIONS:
			currently_counting = false
			punctuation_timer.start(pause_on_comma)
		
		if visible_characters == text.length():
			typing = false

func _input(event):
	if event is InputEventMouseButton and typing:
		visible_counter = text.length()


func type_text(new_text):
	parse_markdown(new_text)
	visible_counter = 0
	currently_counting = true
	typing = true

func parse_markdown(parse_text:String):
	parse_text = parse_text.replace(start_highlight_markdown, "[color=#" + highlight_color.to_html() + "]")
	parse_text = parse_text.replace(end_highlight_markdown, "[/color]")
	
	parse_bbcode(parse_text)

func continue_counting():
	currently_counting = true
