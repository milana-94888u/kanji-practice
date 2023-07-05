extends Control
class_name KanjiDrawinLevel


signal return_to_level_menu_required


func setup() -> void:
	$VBoxContainer/KanjiLabel.text = LoadedKanjiInfo.current_kanji
	$VBoxContainer/AspectRatioContainer/SubViewportContainer/KanjiCanvas.setup()


func _ready() -> void:
	setup()


func _on_kanji_canvas_drawing_finished() -> void:
	emit_signal("return_to_level_menu_required")
