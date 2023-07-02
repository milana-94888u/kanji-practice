extends Object
class_name SvgPathParser


static func parse(content: String) -> Array[SvgPathCommand]:
	var parser := SvgPathParser.new(content)
	parser._parse()
	return parser.commands


var reader: SvgPathReader
var position: Vector2
var commands: Array[SvgPathCommand]


func _init(content: String) -> void:
	reader = SvgPathReader.new(content)
	position = Vector2.ZERO
	commands = []


func _parse() -> void:
	while _parse_command():
		pass


func _parse_command() -> bool:
	match reader.read_command_letter():
		"M":
			return _parse_move_command(false)
		"m":
			return _parse_move_command(true)
		"L":
			return _parse_line_command(false)
		"l":
			return _parse_line_command(true)
		"H":
			return _parse_horizontal_line_command(false)
		"h":
			return _parse_horizontal_line_command(true)
		"V":
			return _parse_vertical_line_command(false)
		"v":
			return _parse_vertical_line_command(true)
		"Q":
			return _parse_quadratic_curve_command(false)
		"q":
			return _parse_quadratic_curve_command(true)
		"T":
			return _parse_smooth_quadratic_curve_command(false)
		"t":
			return _parse_smooth_quadratic_curve_command(true)
		"C":
			return _parse_cubic_curve_command(false)
		"c":
			return _parse_cubic_curve_command(true)
		"S":
			return _parse_smooth_cubic_curve_command(false)
		"s":
			return _parse_smooth_cubic_curve_command(true)
		"A":
			return _parse_ellictical_arc_command(false)
		"a":
			return _parse_ellictical_arc_command(true)
		"Z":
			return _parse_close_command(false)
		"z":
			return _parse_close_command(true)
		_:
			return false


func _get_quadratic_smooth_point() -> Vector2:
	var smooth_point := position
	if not commands.is_empty():
		var previous_command = commands[-1]
		if previous_command is SvgPathCommandQuadraticCurve:
			smooth_point = previous_command.control_point
	return smooth_point


func _get_cubic_smooth_point() -> Vector2:
	var smooth_point := position
	if not commands.is_empty():
		var previous_command = commands[-1]
		if previous_command is SvgPathCommandCubicCurve:
			smooth_point = previous_command.second_control_point
	return smooth_point


func _parse_vector() -> Vector2:
	return Vector2(reader.read_float(), reader.read_float())


func _all_nans(vecs: Array[Vector2]) -> bool:
	var result := true
	for vec in vecs:
		result = result and is_nan(vec.x) and is_nan(vec.y)
	return result


func _any_nan(vecs: Array[Vector2]) -> bool:
	var result := false
	for vec in vecs:
		result = result or is_nan(vec.x) or is_nan(vec.y)
	return result


func _parse_move_command(is_relative: bool) -> bool:
	var move_vector := _parse_vector()
	if _all_nans([move_vector]):
		return false
	while not(_all_nans([move_vector])):
		if _any_nan([move_vector]):
			return false
		if is_relative:
			move_vector += position
		commands.push_back(SvgPathCommandMove.new(position, move_vector))
		position = move_vector
		move_vector = _parse_vector()
	return true


func _parse_line_command(is_relative: bool) -> bool:
	var move_vector := _parse_vector()
	if _all_nans([move_vector]):
		return false
	while not(_all_nans([move_vector])):
		if _any_nan([move_vector]):
			return false
		if is_relative:
			move_vector += position
		commands.push_back(SvgPathCommandLine.new(position, move_vector))
		position = move_vector
		move_vector = _parse_vector()
	return true


func _parse_horizontal_line_command(is_relative: bool) -> bool:
	var move_length := reader.read_float()
	if is_nan(move_length):
		return false
	while not is_nan(move_length):
		var move_vector := Vector2(move_length, 0)
		if is_relative:
			move_vector += position
		commands.push_back(SvgPathCommandLine.new(position, move_vector))
		position = move_vector
		move_length = reader.read_float()
	return true


func _parse_vertical_line_command(is_relative: bool) -> bool:
	var move_length := reader.read_float()
	if is_nan(move_length):
		return false
	while not is_nan(move_length):
		var move_vector := Vector2(0, move_length)
		if is_relative:
			move_vector += position
		commands.push_back(SvgPathCommandLine.new(position, move_vector))
		position = move_vector
		move_length = reader.read_float()
	return true


func _parse_quadratic_curve_command(is_relative: bool) -> bool:
	var control_vector := _parse_vector()
	var move_vector := _parse_vector()
	if _all_nans([control_vector, move_vector]):
		return false
	while not(_all_nans([control_vector, move_vector])):
		if _any_nan([control_vector, move_vector]):
			return false
		if is_relative:
			control_vector += position
			move_vector += position
		commands.push_back(SvgPathCommandQuadraticCurve.new(position, control_vector, move_vector))
		position = move_vector
		control_vector = _parse_vector()
		move_vector = _parse_vector()
	return true


func _parse_smooth_quadratic_curve_command(is_relative: bool) -> bool:
	var move_vector := _parse_vector()
	if _all_nans([move_vector]):
		return false
	while not(_all_nans([move_vector])):
		if _any_nan([move_vector]):
			return false
		if is_relative:
			move_vector += position
		var control_vector := position + position - _get_quadratic_smooth_point()
		commands.push_back(SvgPathCommandQuadraticCurve.new(position, control_vector, move_vector))
		position = move_vector
		move_vector = _parse_vector()
	return true


func _parse_cubic_curve_command(is_relative: bool) -> bool:
	var first_control_vector := _parse_vector()
	var second_control_vector := _parse_vector()
	var move_vector := _parse_vector()
	if _all_nans([first_control_vector, second_control_vector, move_vector]):
		return false
	while not(_all_nans([first_control_vector, second_control_vector, move_vector])):
		if _any_nan([first_control_vector, second_control_vector, move_vector]):
			return false
		if is_relative:
			first_control_vector += position
			second_control_vector += position
			move_vector += position
		commands.push_back(SvgPathCommandCubicCurve.new(position, first_control_vector, second_control_vector, move_vector))
		position = move_vector
		first_control_vector = _parse_vector()
		second_control_vector = _parse_vector()
		move_vector = _parse_vector()
	return true


func _parse_smooth_cubic_curve_command(is_relative: bool) -> bool:
	var second_control_vector := _parse_vector()
	var move_vector := _parse_vector()
	if _all_nans([second_control_vector, move_vector]):
		return false
	while not(_all_nans([second_control_vector, move_vector])):
		if _any_nan([second_control_vector, move_vector]):
			return false
		if is_relative:
			second_control_vector += position
			move_vector += position
		var first_control_vector := position + position - _get_cubic_smooth_point()
		commands.push_back(SvgPathCommandCubicCurve.new(position, first_control_vector, second_control_vector, move_vector))
		position = move_vector
		second_control_vector = _parse_vector()
		move_vector = _parse_vector()
	return true


func _parse_ellictical_arc_command(is_relative: bool) -> bool:
	var radiuses_vector := _parse_vector()
	var x_rotation := reader.read_float()
	var large_arc_flag := reader.read_flag()
	var sweep_flag := reader.read_flag()
	var move_vector := _parse_vector()
	if _all_nans([radiuses_vector, move_vector]):
		return false
	while not(_all_nans([radiuses_vector, move_vector])):
		if _any_nan([radiuses_vector, move_vector]):
			return false
		if is_relative:
			move_vector += position
		commands.push_back(SvgPathCommandEllipticalArc.new(position, radiuses_vector, x_rotation, large_arc_flag, sweep_flag, move_vector))
		position = move_vector
		radiuses_vector = _parse_vector()
		x_rotation = reader.read_float()
		large_arc_flag = reader.read_flag()
		sweep_flag = reader.read_flag()
		move_vector = _parse_vector()
	return true


func _parse_close_command(_is_relative: bool) -> bool:
	var segment_start := position
	for i in commands.size():
		if commands[-i - 1] is SvgPathCommandMove:
			segment_start = commands[-i - 1].end_point
			break
		segment_start = commands[-i - 1].start_point
	commands.push_back(SvgPathCommandLine.new(position, segment_start))
	position = segment_start
	return true
