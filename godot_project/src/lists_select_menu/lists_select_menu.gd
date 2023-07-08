extends Control


@onready var packed_tab_container := preload("res://src/lists_select_menu/tab_container.tscn")


func _ready() -> void:
	remove_child($TabContainer)
	var tab_container := packed_tab_container.instantiate()
	add_child(tab_container)
	for kanji_lists_block in KanjiListsManager.kanji_lists:
		var kanji_lists_block_tab := packed_tab_container.instantiate()
		kanji_lists_block_tab.name = kanji_lists_block
		tab_container.add_child(kanji_lists_block_tab)
		for kanji_list_name in KanjiListsManager.kanji_lists.get(kanji_lists_block):
			kanji_lists_block_tab.add_child(KanjiListsManager.kanji_lists_controls[kanji_list_name])