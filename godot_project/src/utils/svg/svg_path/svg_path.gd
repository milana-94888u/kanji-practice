extends SvgElement
class_name SvgPath


var commands: Array[SvgPathCommand]
var length: float
var position: Vector2


func _init(attributes: Dictionary) -> void:
	commands = SvgPathParser.parse(attributes.get("d"))
	attributes.erase("d")
	super._init(attributes)

	length = 0.0
	for command in commands:
		length += command.length
	if commands[0] is SvgPathCommandMove:
		position = commands[0].end_point
	else:
		position = commands[0].start_point
	

func split_points_count_proportional(points_count: int) -> Array[int]:
	var result: Array[int] = []
	var remaining_length := length
	var remaining_points_count := points_count
	for command in commands:
		if remaining_length < command.length:
			result.append(0)
			continue
		var current_points_count := floori(
			(command.length / remaining_length) * remaining_points_count
		)
		result.append(current_points_count)
		remaining_points_count -= current_points_count
		remaining_length -= command.length
	return result



func draw(points_count: int, line: Line2D = null) -> Line2D:
	if line == null:
		line = Line2D.new()
	var points_count_proportional := split_points_count_proportional(points_count)
	for command_idx in commands.size():
		line = commands[command_idx].draw(points_count_proportional[command_idx], line)
	return line
