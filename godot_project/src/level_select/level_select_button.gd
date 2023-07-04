extends Button


func _ready() -> void:
	text = LoadedKanjiInfo.current_kanji


func _on_pressed() -> void:
	LoadedKanjiInfo.current_kanji = text
	get_tree().change_scene_to_file("res://src/kanji_drawing_level/kanji_drawing_level.tscn")
