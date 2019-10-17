extends HBoxContainer

onready var entry_field = $entry_field
onready var options_button = $options_button

signal text_entered
signal option_confirmed


# Called when the node enters the scene tree for the first time.
func _ready():
	entry_field.connect("text_confirmed", self, "confirm_text")
	options_button.get_popup().connect("id_pressed", self, "transmit_option")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func name_entry(new_name):
	entry_field.text = new_name.capitalize()
	entry_field.name = "%s_%s" % [new_name, "field"]

func get_value():
	return entry_field.text

func confirm_text(new_text):
	emit_signal("text_entered", new_text)

func transmit_option(id):
	emit_signal("option_confirmed", self, id)
