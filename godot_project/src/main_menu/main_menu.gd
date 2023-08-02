extends Control


var lists_group: Dictionary


func _ready() -> void:
	TranslationServer.set_locale("ru")
	get_tree().set_quit_on_go_back(false)
	if LevelListsManager.current_game_mode == "":
		lists_group = LevelListsManager.level_lists
	elif LevelListsManager.current_list_category == "":
		lists_group = LevelListsManager.level_lists[
			LevelListsManager.current_game_mode
		]
	elif LevelListsManager.current_list_name == "":
		lists_group = LevelListsManager.level_lists[
			LevelListsManager.current_game_mode
		][
			LevelListsManager.current_list_category
		]
	for button_name in lists_group:
		var list_button := Button.new()
		list_button.text = button_name
		list_button.pressed.connect(select_group.bind(list_button.text))
		list_button.mouse_filter = Control.MOUSE_FILTER_PASS
		list_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		$MarginContainer/VBoxContainer.add_child(list_button)


func select_group(group_name: String) -> void:
	if LevelListsManager.current_game_mode == "":
		LevelListsManager.current_game_mode = group_name
		get_tree().reload_current_scene()
	elif LevelListsManager.current_list_category == "":
		LevelListsManager.current_list_category = group_name
		get_tree().reload_current_scene()
	elif LevelListsManager.current_list_name == "":
		LevelListsManager.current_list_name = group_name
		get_tree().change_scene_to_packed(LevelListsManager.level_selection_menu)


func go_back() -> void:
	if LevelListsManager.current_game_mode == "":
		get_tree().quit()
	elif LevelListsManager.current_list_category == "":
		LevelListsManager.current_game_mode = ""
		get_tree().reload_current_scene()
	elif LevelListsManager.current_list_name == "":
		LevelListsManager.current_list_category = ""
		get_tree().reload_current_scene()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_GO_BACK_REQUEST:
			go_back()


func _on_back_button_pressed() -> void:
	go_back()
