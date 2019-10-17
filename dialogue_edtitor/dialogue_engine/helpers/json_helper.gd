extends Node


func load_json(file_path:String):
	var file = File.new()
	
	assert file.file_exists(file_path)
	
	file.open(file_path, file.READ)
	
	var json = parse_json(file.get_as_text())
	
	assert json.size() > 0
	
	file.close()
	
	return json

func save_json(data:Dictionary, file_path:String):
	var file = File.new()
	
	assert file.file_exists(file_path)
	
	file.open(file_path, File.WRITE)
	
	file.store_line(to_json(data))
	
	file.close()