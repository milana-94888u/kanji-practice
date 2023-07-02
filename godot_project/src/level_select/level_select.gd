extends Control


func _ready() -> void:
	for kanji in LoadedKanjiInfo.kanji_list:
		$ItemList.add_item(kanji, null, false)


func _on_item_list_item_clicked(index: int, _at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index != 1:
		return
	LoadedKanjiInfo.current_kanji = $ItemList.get_item_text(index)
	get_tree().change_scene_to_file("res://src/kanji_canvas/kanji_canvas.tscn")
