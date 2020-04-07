extends Node


func load_json(file_path:String):
	var file = File.new()
	var json = null
	
	if file.file_exists(file_path):
		file.open(file_path, file.READ)
		json = parse_json(file.get_as_text())
		file.close()
	
	return json

func save_json(data:Dictionary, file_path:String):
	var file = File.new()
	var directory = Directory.new()
	
	if not directory.dir_exists(file_path.get_base_dir()):
		directory.make_dir(file_path.get_base_dir())
	
	file.open(file_path, File.WRITE)
	file.store_line(to_json(data))

	file.close()
