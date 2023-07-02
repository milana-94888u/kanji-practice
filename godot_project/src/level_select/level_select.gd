extends Control


func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	LoadedKanjiInfo.current_kanji = $ItemList.get_item_text(index)
	get_tree().change_scene_to_file("res://src/kanji_canvas/kanji_canvas.tscn")
