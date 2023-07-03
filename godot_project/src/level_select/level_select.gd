extends Control


var kanji_select_button_packed := preload("res://src/level_select/level_select_button.tscn")


func _ready() -> void:
	var viewport_rect := get_viewport_rect()
	var square: Vector2 = min(viewport_rect.size.x, viewport_rect.size.y) * 0.9 * Vector2.ONE
	$ScrollContainer.position = (viewport_rect.position + viewport_rect.end - square) / 2
	$ScrollContainer.scale = square / $ScrollContainer.size

	for kanji in LoadedKanjiInfo.kanji_list:
		var kanji_button := kanji_select_button_packed.instantiate() as Button
		kanji_button.text = kanji
		$ScrollContainer/GridContainer.add_child(kanji_button)
