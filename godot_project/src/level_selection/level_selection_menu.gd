extends Control


signal level_selected
signal return_to_level_menu_required


func _on_level_selection_list_level_selected() -> void:
	$LevelSelectionList.visible = false
	$KanjiDrawingLevel.setup()
	$KanjiDrawingLevel.visible = true
	level_selected.emit()


func _on_kanji_drawing_level_return_to_level_menu_required() -> void:
	$KanjiDrawingLevel.visible = false
	$LevelSelectionList.visible = true
	return_to_level_menu_required.emit()


func add_buttons_batch() -> bool:
	return $LevelSelectionList.add_buttons_batch()
