extends Control


signal level_selected


var kanji_select_button_packed := preload("res://src/level_select_old/level_select_button.tscn")


func _ready() -> void:
	(get_parent() as ScrollContainer).get_v_scroll_bar().size.x = 20
	for kanji in LoadedKanjiInfo.kanji_list:
		LoadedKanjiInfo.current_kanji = kanji
		var kanji_button := kanji_select_button_packed.instantiate() as Button
		kanji_button.connect("level_selected", _process_select)
		add_child(kanji_button)


func _process_select() -> void:
	emit_signal("level_selected")
