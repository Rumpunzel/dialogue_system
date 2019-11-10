extends Node


func list_files_in_directory(directory_path:String, recursive:bool, directory_as_key:String = ""):
	var files = []
	var directory = Directory.new()
	
	directory.open(directory_path)
	directory.list_dir_begin(true)
	
	while true:
		var file = directory.get_next()
		
		if file == "":
			break
		elif directory.current_is_dir():
			if recursive:
				files.append(list_files_in_directory(directory_path.plus_file(file), recursive, file))
		else:
			files.append(file)
			
			if CONSTANTS.verbose_mode:
				CONSTANTS.print_to_console("Found file %s in directory %s" % [file, directory_path])
	
	directory.list_dir_end()
	
	return files if directory_as_key.length() == 0 else { directory_as_key: files }
