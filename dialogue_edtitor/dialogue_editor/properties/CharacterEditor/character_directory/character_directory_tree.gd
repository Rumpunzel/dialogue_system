extends directory_tree

func load_entries():
	return json_helper.load_json(Character.json_paths[Character.STATS_PATHS.MODIFIED]).keys()
