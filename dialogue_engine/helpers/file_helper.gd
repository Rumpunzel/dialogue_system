extends Node


func list_files_in_directory(directory_path:String, recursive:bool, file_suffix:String = ""):
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
				files += list_files_in_directory(directory_path.plus_file(file), recursive, file_suffix)
		elif file.ends_with(file_suffix):
			files.append(directory_path.plus_file(file))
			
			if CONSTANTS.verbose_mode:
				CONSTANTS.print_to_console("Found file %s in directory %s" % [file, directory_path])
	
	directory.list_dir_end()
	
	return files

func delete_file(file_path:String):
	var directory = Directory.new()
	directory.remove(file_path)
