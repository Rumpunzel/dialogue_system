extends Node


func load_json(file_path):
	var file = File.new()
	print(file_path)
	assert file.file_exists(file_path)
	
	file.open(file_path, file.READ)
	
	var json = parse_json(file.get_as_text())
	
	assert json.size() > 0
	
	return json
