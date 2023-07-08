extends Node

enum GameMode {
	RECOGNITION,
	READING,
	KANJI_WRITING,
	WORD_WRITING,
}


func add_kanji_list(lists_block: String, kanji_list_name: String, kanji_list: Array) -> void:
	kanji_lists[lists_block][kanji_list_name] = kanji_list
	for kanji in kanji_list:
		kanji_scores["recognition"][kanji] = 0.0
		kanji_scores["writing"][kanji] = 0.0
		if kanji_in_lists.has(kanji):
			kanji_in_lists[kanji].append(kanji_list)
		else:
			kanji_in_lists[kanji] = [kanji_list]


func add_to_kanji_lists(kanji_list_name: String, kanji_list: Array) -> void:
	if kanji_list_name == "hiragana" or kanji_list_name == "katakana":
		add_kanji_list("kana", kanji_list_name, kanji_list)
	elif kanji_list_name.begins_with("kanji_jlpt"):
		add_kanji_list("jlpt", kanji_list_name, kanji_list)
	elif kanji_list_name.begins_with("kanji_kanken"):
		if kanji_list_name.ends_with("1") or kanji_list_name.ends_with("1.5"):
			add_kanji_list("advanced", kanji_list_name, kanji_list)
		elif (
			kanji_list_name.ends_with("2") or
			kanji_list_name.ends_with("2.5") or
			kanji_list_name.ends_with("3") or
			kanji_list_name.ends_with("4")
		):
			add_kanji_list("secondary", kanji_list_name, kanji_list)
		else:
			add_kanji_list("primary", kanji_list_name, kanji_list)
	elif kanji_list_name.begins_with("kanji_jinmeiyou"):
		add_kanji_list("jinmeiyou", kanji_list_name, kanji_list)
	else:
		add_kanji_list("user", kanji_list_name, kanji_list)


func fill_kanji_list_from_file(path: String) -> bool:
	if not FileAccess.file_exists(path):
		return false
	var kanji_file := FileAccess.open(path, FileAccess.READ)
	var parsed_lists: Dictionary = JSON.parse_string(kanji_file.get_as_text())
	for kanji_list_name in parsed_lists:
		add_to_kanji_lists(kanji_list_name, parsed_lists.get(kanji_list_name) as Array)
	return true


func fill_kanji_scores(path: String) -> void:
	if not FileAccess.file_exists(path):
		return
	var kanji_file := FileAccess.open(path, FileAccess.READ)
	kanji_scores = JSON.parse_string(kanji_file.get_as_text())


func _ready() -> void:
	if fill_kanji_list_from_file("user://kanji_lists.json"):
		fill_kanji_scores("user://kanji_scores.json")
	else:
		fill_kanji_list_from_file("res://assets/kanji_lists.json")


var kanji_in_lists := {}
var kanji_scores := {
	"recognition": {},
	"writing": {},
}


var kanji_lists := {
	"kana": {
		"hiragana": [],
		"katakana": [],
	},
	"jlpt": {
		"kanji_jlpt5": [],
		"kanji_jlpt4": [],
		"kanji_jlpt3": [],
		"kanji_jlpt2": [],
		"kanji_jlpt1": [],
	},
	"primary": {
		"kanji_kanken10": [],
		"kanji_kanken9": [],
		"kanji_kanken8": [],
		"kanji_kanken7": [],
		"kanji_kanken6": [],
		"kanji_kanken5": [],
	},
	"secondary": {
		"kanji_kanken4": [],
		"kanji_kanken3": [],
		"kanji_kanken2.5": [],
		"kanji_kanken2": [],
	},
	"advanced": {
		"kanji_kanken1.5": [],
		"kanji_kanken1": [],
	},
	"jinmeiyou": {
		"kanji_jinmeiyou_simple": [],
		"kanji_jinmeiyou_forms": [],
	},
	"user": {},
}

var word_lists := {
	"jlpt": {
		"word_jlpt5": [],
		"word_jlpt4": [],
		"word_jlpt3": [],
		"word_jlpt2": [],
		"word_jlpt1": [],
	},
	"frequent": {
		"word_frequent1000": [],
		"word_frequent2000": [],
		"word_frequent3000": [],
		"word_frequent4000": [],
		"word_frequent5000": [],
		"word_frequent6000": [],
	},
}
