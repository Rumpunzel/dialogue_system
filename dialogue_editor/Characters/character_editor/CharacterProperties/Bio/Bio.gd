extends MarginContainer

signal new_bio


# Called when the node enters the scene tree for the first time.
func _ready():
	$bio_text.connect("new_text", self, "update_bio")


func update_bio(new_text):
	emit_signal("new_bio", new_text)

func set_bio(new_text):
	$bio_text.text = new_text
