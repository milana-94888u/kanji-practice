extends Control


@onready var tab_container := $TabContainer
var kanji_lists: Array[Control]
var kanji_list_idx := 0


func _process(_delta: float) -> void:
	if kanji_list_idx < kanji_lists.size():
		if kanji_lists[kanji_list_idx].add_buttons_batch():
			kanji_list_idx += 1
	else:
		set_process(false)


func _ready() -> void:
	for kanji_lists_block in KanjiListsManager.kanji_lists:
		add_kanji_lists_block_tab(kanji_lists_block)


func add_kanji_lists_block_tab(kanji_lists_block: String) -> void:
	var kanji_lists_block_tab := TabContainer.new()
	kanji_lists_block_tab.set_anchors_preset(Control.PRESET_FULL_RECT)
	kanji_lists_block_tab.name = kanji_lists_block
	tab_container.add_child(kanji_lists_block_tab)
	for kanji_list_name in KanjiListsManager.kanji_lists.get(kanji_lists_block):
		kanji_lists.append(KanjiListsManager.kanji_lists_controls[kanji_list_name])
		KanjiListsManager.kanji_lists_controls[kanji_list_name].connect("level_selected", func(): set_process(false))
		KanjiListsManager.kanji_lists_controls[kanji_list_name].connect("return_to_level_menu_required", func(): set_process(true))
		kanji_lists_block_tab.add_child(KanjiListsManager.kanji_lists_controls[kanji_list_name])


func _on_tab_container_tab_changed(tab: int) -> void:
	var kanji_lists_block_tab := tab_container.get_tab_control(tab) as TabContainer
	if kanji_lists_block_tab.get_child_count():
		return
	for kanji_list_name in KanjiListsManager.kanji_lists.get(kanji_lists_block_tab.name):
		kanji_lists_block_tab.add_child(KanjiListsManager.kanji_lists_controls[kanji_list_name])
		

func change_owner(nodes: Array[Node]) -> void:
	for node in nodes:
		node.owner = self
		change_owner(node.get_children())


func save_scene() -> void:
	change_owner(get_children())
	
	var scene := PackedScene.new()
	if scene.pack(self) == OK:
		var error = ResourceSaver.save(scene, "res://main_menu.tscn")
		if error == OK:
			print("OK")
