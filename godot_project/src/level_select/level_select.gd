extends Control


func _on_grid_container_level_selected() -> void:
	$AspectRatioContainer.visible = false
	$KanjiDrawingLevel.setup()
	$KanjiDrawingLevel.visible = true


func _on_kanji_drawing_level_return_to_level_menu_required() -> void:
	$KanjiDrawingLevel.visible = false
	$AspectRatioContainer.visible = true
