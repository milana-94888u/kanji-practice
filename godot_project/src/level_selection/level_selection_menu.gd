extends Control


func _on_level_selection_list_level_selected() -> void:
	$LevelSelectionList.visible = false
	$KanjiDrawingLevel.setup()
	$KanjiDrawingLevel.visible = true


func _on_kanji_drawing_level_return_to_level_menu_required() -> void:
	$KanjiDrawingLevel.visible = false
	$LevelSelectionList.visible = true
