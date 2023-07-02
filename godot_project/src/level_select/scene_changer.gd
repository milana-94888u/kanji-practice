extends Node


@onready var packed_kanji_canvas := preload("res://src/kanji_canvas/kanji_canvas.tscn")
@onready var level_select := $LevelSelect

var kanji_canvas


func _ready() -> void:
	$LevelSelect.connect("level_selected", _switch_to_level)


func _switch_to_level(svg_path: String) -> void:
	kanji_canvas = packed_kanji_canvas.instantiate()
	kanji_canvas.setup(svg_path)
	kanji_canvas.connect("kanji_finished", _return_to_menu)
	remove_child(level_select)
	add_child(kanji_canvas)


func _return_to_menu() -> void:
	remove_child(kanji_canvas)
	add_child(level_select)
