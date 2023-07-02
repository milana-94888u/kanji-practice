extends SvgPathCommand
class_name SvgPathCommandLine


func _init(position: Vector2, end: Vector2) -> void:
	super._init(position, end)
	length = (end_point - start_point).length()


func draw(num_of_points := 0, line: Line2D = null) -> Line2D:
	if line == null:
		line = Line2D.new()
	if num_of_points == 0:
		num_of_points = 2

	for i in num_of_points:
		line.add_point(point_at(float(i) / num_of_points))
	return line


func point_at(weight: float) -> Vector2:
	return start_point.lerp(end_point, weight)
