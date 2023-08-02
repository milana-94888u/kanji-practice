extends Node


@export var level_selection_menu: PackedScene = preload("res://src/level_selection/level_selection_menu.tscn")
@export var main_menu: PackedScene = preload("res://src/main_menu/main_menu.tscn")
@export var kanji_drawing_level: PackedScene = preload("res://src/kanji_drawing_level/kanji_drawing_level.tscn")


var level_lists := {}
var level_scores := {
	"recognition": {},
	"reading": {},
	"writing": {},
	"word_writing": {},
}
var kanji_in_lists := {
	"recognition": {},
	"reading": {},
	"writing": {},
	"word_writing": {},
}


var current_game_mode := ""
var current_list_category := ""
var current_list_name := ""
var current_level := ""


func add_game_mode_lists(game_mode_name: String, game_mode_lists: Dictionary) -> void:
	level_lists[game_mode_name] = {}
	for level_list_category in game_mode_lists:
		level_lists[game_mode_name][level_list_category] = {}
		for level_list_name in game_mode_lists[level_list_category]:
			var level_list: Array[String] = []
			for level_name in game_mode_lists[level_list_category][level_list_name]:
				level_list.append(level_name)
				level_scores[game_mode_name][level_name] = 0.0
				if kanji_in_lists.has(level_name):
					kanji_in_lists[game_mode_name][level_name].append(level_list)
				else:
					kanji_in_lists[game_mode_name][level_name] = [level_list]
			level_lists[game_mode_name][level_list_category][level_list_name] = level_list
			


func fill_level_lists_from_file(path: String) -> bool:
	if not FileAccess.file_exists(path):
		return false
	var level_lists_file := FileAccess.open(path, FileAccess.READ)
	var parsed_lists: Dictionary = JSON.parse_string(level_lists_file.get_as_text())
	for game_mode_name in parsed_lists:
		add_game_mode_lists(game_mode_name, parsed_lists[game_mode_name])
	return true


func fill_level_scores_from_file(path: String) -> void:
	if not FileAccess.file_exists(path):
		return
	var kanji_file := FileAccess.open(path, FileAccess.READ)
	level_scores = JSON.parse_string(kanji_file.get_as_text())


func _ready() -> void:
	if fill_level_lists_from_file("user://level_lists.json"):
		fill_level_scores_from_file("user://level_scores.json")
	else:
		fill_level_lists_from_file("res://assets/level_lists.json")
