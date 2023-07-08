extends HFlowContainer


func _ready() -> void:
	for kanji in LoadedKanjiInfo.kanji_list:
		var kanji_button := Button.new()
		kanji_button.text = kanji
		kanji_button.pressed.connect(select_level.bind(kanji_button.text))
		add_child(kanji_button)


func select_level(kanji: String) -> void:
	print(kanji)
