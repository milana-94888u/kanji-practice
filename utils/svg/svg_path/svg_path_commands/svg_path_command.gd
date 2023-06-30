extends Object
class_name SvgPathCommand


var start_point: Vector2
var end_point: Vector2

var length := 0.0


func _init(position: Vector2, end: Vector2) -> void:
	start_point = position
	end_point = end


func draw(_num_of_points := 0, line: Line2D = null) -> Line2D:
	if line == null:
		line = Line2D.new()
	return line


func point_at(weight: float) -> Vector2:
	return start_point.lerp(end_point, weight)


func _calc_line_length(line: Line2D) -> float:
	var result := 0.0
	for i in range(1, line.get_point_count()):
		result += (line.get_point_position(i) - line.get_point_position(i - 1)).length()
	return result
