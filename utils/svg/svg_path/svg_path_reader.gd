extends Object
class_name SvgPathReader

var separator_regex := RegEx.create_from_string("[\\s,]*")
var command_letter_regex := RegEx.create_from_string("[MmLlHhVvQqTtCcSsAaZz]")
var float_regex := RegEx.create_from_string("[-+]?[0-9]*\\.?[0-9]+(?:[eE][-+]?[0-9]+)?")
var flag_regex := RegEx.create_from_string("[01]")


var content: String
var index: int


func _init(path_str: String) -> void:
	content = path_str
	index = 0


func _check_match(regex_match: RegExMatch) -> bool:
	return regex_match and regex_match.get_start() == index


func read_command_letter() -> String:
	_skip_separator()
	var command_letter_match := command_letter_regex.search(content, index)
	if _check_match(command_letter_match):
		index = command_letter_match.get_end()
		return command_letter_match.get_string()
	return ""


func read_float() -> float:
	_skip_separator()
	var float_match := float_regex.search(content, index)
	if _check_match(float_match):
		index = float_match.get_end()
		return float(float_match.get_string())
	return NAN


func read_flag() -> bool:
	_skip_separator()
	var flag_match := flag_regex.search(content, index)
	if _check_match(flag_match):
		index = flag_match.get_end()
		return flag_match.get_string() == "1"
	return false


func _skip_separator() -> void:
	var separator_match := separator_regex.search(content, index)
	if _check_match(separator_match):
		index = separator_match.get_end()
