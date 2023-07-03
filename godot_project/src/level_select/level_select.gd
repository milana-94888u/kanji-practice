extends Control


@onready var grid := $VBoxContainer/GridAspectAspect/GridAspect/GridContainer


var kanji_select_button_packed := preload("res://src/level_select/level_select_button.tscn")

var current_block := 0


func _ready() -> void:
	_fill_with_kanjis()
	_update_page_label()
	if LoadedKanjiInfo.kanji_list.size() <= 100:
		$VBoxContainer/PanelContainer/ButtonRight.disabled = true


func _fill_with_kanjis() -> void:
	for child in grid.get_children():
		grid.remove_child(child)

	var kanji_count := 100 if (
		LoadedKanjiInfo.kanji_list.size() > current_block * 100 + 100
	) else (
		LoadedKanjiInfo.kanji_list.size() - current_block * 100
	)
	var lines := (kanji_count - 1) / 10 + 1
	$VBoxContainer/GridAspectAspect/GridAspect.ratio = 10.0 / lines
	for kanji in LoadedKanjiInfo.kanji_list.slice(current_block * 100, current_block * 100 + 100):
		var kanji_button := kanji_select_button_packed.instantiate() as Control
		LoadedKanjiInfo.current_kanji = kanji
		grid.add_child(kanji_button)


func _update_page_label() -> void:
	$VBoxContainer/PanelContainer/LabelPage.text = "%d / %d" % [
		current_block + 1, (LoadedKanjiInfo.kanji_list.size() - 1) / 100 + 1
	]


func _on_button_left_pressed() -> void:
	if current_block > 0:
		current_block -= 1
		_fill_with_kanjis()
		$VBoxContainer/PanelContainer/ButtonRight.disabled = false
	if current_block == 0:
		$VBoxContainer/PanelContainer/ButtonLeft.disabled = true
	_update_page_label()


func _on_button_right_pressed() -> void:
	if current_block < (LoadedKanjiInfo.kanji_list.size() - 1) / 100:
		current_block += 1
		_fill_with_kanjis()
		$VBoxContainer/PanelContainer/ButtonLeft.disabled = false
	if current_block == (LoadedKanjiInfo.kanji_list.size() - 1) / 100:
		$VBoxContainer/PanelContainer/ButtonRight.disabled = true
	_update_page_label()
