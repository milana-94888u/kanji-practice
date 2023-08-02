extends Control


signal return_to_level_menu_required


func setup() -> void:
	$VBoxContainer/KanjiLabel.text = LevelListsManager.current_level
	$VBoxContainer/AspectRatioContainer/SubViewportContainer/KanjiCanvas.setup()


func _ready() -> void:
	setup()


func _on_kanji_canvas_drawing_finished() -> void:
	get_tree().change_scene_to_packed(LevelListsManager.level_selection_menu)
