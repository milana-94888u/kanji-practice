extends AspectRatioContainer


signal level_selected


@onready var buttons_container = $SubViewportContainer/SubViewport/ScrollContainer/HFlowContainer

var kanji_list: Array
var offset_idx: int


func _init() -> void:
	kanji_list = LoadedKanjiInfo.kanji_list


func _ready() -> void:
	offset_idx = 0


func add_buttons_batch() -> bool:
	if offset_idx >= kanji_list.size():
		return true
	fill_with_data()
	offset_idx += 100
	return false


func fill_with_data() -> void:
	for kanji in kanji_list.slice(offset_idx, offset_idx + 100):
		var kanji_button := Button.new()
		kanji_button.text = kanji
		kanji_button.mouse_filter = Control.MOUSE_FILTER_PASS
		kanji_button.pressed.connect(select_level.bind(kanji_button.text))
		buttons_container.add_child(kanji_button)


func select_level(kanji: String) -> void:
	LoadedKanjiInfo.current_kanji = kanji
	emit_signal("level_selected")
