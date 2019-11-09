extends directory_entry


func _on_open_pressed():
	get_node("/root/main/editor/Characters").open_new_tab($name.text)
