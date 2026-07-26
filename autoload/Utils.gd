extends Node

func kill_and_create_tween(tween: Tween = null) -> Tween:
	if tween and tween.is_running():
		tween.kill()
	return create_tween()

func load_files_from_path(path: String) -> Array:
	var arr: Array = []
	
	print("loading resources from: ", path)
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if not dir.current_is_dir():
				if file.get_extension() == "remap":
					file = file.replace(".remap", "")
				var res = load(path+file)
				if res:
					arr.append(res)
	
			file = dir.get_next()
	else:
		printerr("An error occurred when trying to access the path.")
	
	#print("Loaded: ", arr)
	
	return arr
