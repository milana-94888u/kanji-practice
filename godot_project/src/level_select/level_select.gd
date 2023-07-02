extends Control


signal level_selected(path_to_svg)


func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	var kanji: String = $ItemList.get_item_text(index)
	emit_signal("level_selected", "res://assets/kanji/%05x.svg" % kanji.unicode_at(0))
