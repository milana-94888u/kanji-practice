extends VBoxContainer


var buttons_container: HFlowContainer


var level_list: Array[String]
var pages: Array[int]
var current_page: int


func calculate_page_end(start_index: int) -> int:
	var lines := 0
	var current_line := 0
	var index := start_index
	while index < len(level_list) and lines < 10:
		var level_name := level_list[index]
		var button_width := len(level_name) * 50 + 2 + (8 if current_line else 0)
		if LevelListsManager.current_level == level_name:
			current_page = len(pages)
		if current_line + button_width > 592:
			lines += 1
			current_line = button_width - (8 if current_line else 0)
		else:
			current_line += button_width
		if lines < 10:
			index += 1
	return index


func split_by_pages() -> void:
	pages = [0]
	var index := 0
	while index < len(level_list):
		index = calculate_page_end(index)
		pages.append(index)
	


func _ready() -> void:
	level_list = LevelListsManager.level_lists[
		LevelListsManager.current_game_mode
	][
		LevelListsManager.current_list_category
	][
		LevelListsManager.current_list_name
	]
	current_page = 1
	split_by_pages()
	if pages:
		set_page(current_page)
	else:
		$HBoxContainer/LeftButton.disabled = true
		$HBoxContainer/RightButton.disabled = true


func fill_page(page: int) -> void:
	if buttons_container != null:
		$AspectRatioContainer/MarginContainer.remove_child(buttons_container)
	buttons_container = HFlowContainer.new()
	buttons_container.alignment = FlowContainer.ALIGNMENT_CENTER
	$AspectRatioContainer/MarginContainer.add_child(buttons_container)
	for level_name in level_list.slice(pages[page - 1], pages[page]):
		var level_button := Button.new()
		level_button.text = level_name
		level_button.mouse_filter = Control.MOUSE_FILTER_PASS
		level_button.pressed.connect(select_level.bind(level_button.text))
		level_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		buttons_container.add_child(level_button)


func set_page(page: int) -> void:
	current_page = page
	$HBoxContainer/LeftButton.disabled = false
	$HBoxContainer/RightButton.disabled = false
	if page == 1:
		$HBoxContainer/LeftButton.disabled = true
	if page == len(pages) - 1:
		$HBoxContainer/RightButton.disabled = true
	$HBoxContainer/Label.text = "%d / %d" % [page, len(pages) - 1]
	fill_page(page)


func select_level(level_name: String) -> void:
	LevelListsManager.current_level = level_name
	get_tree().change_scene_to_packed(LevelListsManager.kanji_drawing_level)


func _on_left_button_pressed() -> void:
	set_page(current_page - 1)


func _on_right_button_pressed() -> void:
	set_page(current_page + 1)


func go_back() -> void:
	LevelListsManager.current_list_name = ""
	get_tree().change_scene_to_packed(LevelListsManager.main_menu)


func _on_back_button_pressed() -> void:
	go_back()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_GO_BACK_REQUEST:
			go_back()
