extends Control


func _ready() -> void:
	$VBoxContainer/KanjiLabel.text = LoadedKanjiInfo.current_kanji
