@tool
extends EditorScript

## Builds one ArtificialIntelligence resource per group from a CSV of
## "key,emotion,group" rows. Every key sharing a group ends up in the same
## `pair` dictionary, and the resource is named after the group's first key
## minus its last character (GAME_OVER_LAYA0 -> game_over_laya.tres).
##
## Open this file in the script editor and hit File > Run (Ctrl+Shift+X).

## Source CSV. Columns are read by index, so a sheet with extra columns works too.
const CSV_PATH : String = "res://resources/AI/csv/ai_discussion.csv"
const KEY_COLUMN : int = 0
const EMOTION_COLUMN : int = 1
const GROUP_COLUMN : int = 2

const OUT_DIR : String = "res://resources/AI/generated"

## Header rows are detected by their key instead of their position:
## in the localization sheet the header ends up sorted in the middle of the file.
const HEADER_KEYS : PackedStringArray = ["key", "keys", "formated_key"]


func _run() -> void:
	var rows : Array[PackedStringArray] = _read_csv(CSV_PATH)
	if rows.is_empty():
		push_error("No usable row found in %s" % CSV_PATH)
		return

	# group id -> Array of [key, emotion]. Dictionaries keep insertion order,
	# so the first entry of a group stays the one that names the resource.
	var groups : Dictionary = {}
	for row in rows:
		var key : String = row[KEY_COLUMN].strip_edges()
		var raw_group : String = row[GROUP_COLUMN].strip_edges()
		if not raw_group.is_valid_int():
			push_warning("Skipped '%s': group '%s' is not an integer" % [key, raw_group])
			continue
		var emotion : int = _parse_emotion(row[EMOTION_COLUMN])
		if emotion < 0:
			push_warning("Skipped '%s': unknown emotion '%s'" % [key, row[EMOTION_COLUMN]])
			continue
		var group : int = raw_group.to_int()
		if not groups.has(group):
			groups[group] = []
		groups[group].append([key, emotion])

	DirAccess.make_dir_recursive_absolute(OUT_DIR)
	var saved : int = 0
	var used_paths : Dictionary = {}
	for group in groups:
		var entries : Array = groups[group]
		var first_key : String = entries[0][0]
		var res_name : String = first_key.left(-1)
		if res_name.is_empty():
			push_warning("Group %d: first key '%s' is too short to name a resource" % [group, first_key])
			continue

		var path : String = "%s/%s.tres" % [OUT_DIR, res_name.to_lower()]
		if used_paths.has(path):
			push_warning("Group %d and group %d both map to %s" % [group, used_paths[path], path])
			continue
		used_paths[path] = group

		# Reuse the existing resource when there is one, so hand-edited fields survive.
		var ai : ArtificialIntelligence = null
		if ResourceLoader.exists(path):
			ai = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if ai == null:
			ai = ArtificialIntelligence.new()

		ai.pair.clear()
		for entry in entries:
			var key : String = entry[0]
			if ai.pair.has(key):
				push_warning("Group %d: duplicate key '%s', keeping the last emotion" % [group, key])
			ai.pair[key] = entry[1]

		# The group opens on the emotion of its first line.
		ai.emotion = entries[0][1]
		if ai.sprite == null:
			ai.sprite = _face_for(ai.emotion)

		if _save(ai, path):
			saved += 1

	print("import_ai_emotions: %d resources written to %s" % [saved, OUT_DIR])
	EditorInterface.get_resource_filesystem().scan()


## Reads the CSV, dropping header and malformed rows.
## get_csv_line() handles quoted fields and newlines inside quotes.
func _read_csv(path: String) -> Array[PackedStringArray]:
	var rows : Array[PackedStringArray] = []
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Cannot open %s: %s" % [path, error_string(FileAccess.get_open_error())])
		return rows

	var needed : int = maxi(maxi(KEY_COLUMN, EMOTION_COLUMN), GROUP_COLUMN) + 1
	while not file.eof_reached():
		var line : PackedStringArray = file.get_csv_line()
		if line.size() < needed:
			continue
		var key : String = line[KEY_COLUMN].strip_edges()
		if key.is_empty() or HEADER_KEYS.has(key.to_lower()):
			continue
		rows.append(line)
	return rows


## Accepts "HAPPY_IN_LOVE", "happy in love", "Happy-In-Love" or the raw enum index.
func _parse_emotion(raw: String) -> int:
	var name : String = raw.strip_edges().to_upper().replace(" ", "_").replace("-", "_")
	if ArtificialIntelligence.Emotion.has(name):
		return ArtificialIntelligence.Emotion[name]
	if name.is_valid_int() and ArtificialIntelligence.Emotion.values().has(name.to_int()):
		return name.to_int()
	return -1


func _face_for(emotion: int) -> Texture2D:
	var face_path : String = ArtificialIntelligence.AI_FACE.get(emotion, "")
	if face_path.is_empty() or not ResourceLoader.exists(face_path):
		return null
	return load(face_path)


func _save(ai: ArtificialIntelligence, path: String) -> bool:
	var err : int = ResourceSaver.save(ai, path)
	if err != OK:
		push_error("Cannot save %s: %s" % [path, error_string(err)])
		return false
	return true
