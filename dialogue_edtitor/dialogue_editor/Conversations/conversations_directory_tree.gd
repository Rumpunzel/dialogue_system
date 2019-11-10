extends directory_tree

export(String, DIR) var conversations_directory

func load_entries():
	return file_helper.list_files_in_directory(conversations_directory, true)
