extends SvgPathCommand
class_name SvgPathCommandQuadraticCurve


var control_point: Vector2


func _init(position: Vector2, control: Vector2, end: Vector2) -> void:
	super._init(position, end)
	control_point = control
	length = _calc_line_length(draw())


func draw(num_of_points := 0, line: Line2D = null) -> Line2D:
	if line == null:
		line = Line2D.new()
	if num_of_points == 0:
		num_of_points = 1000

	for i in num_of_points:
		line.add_point(point_at(float(i) / num_of_points))
	return line


func point_at(weight: float) -> Vector2:
	var q0 := start_point.lerp(control_point, weight)
	var q1 := control_point.lerp(end_point, weight)
	
	return q0.lerp(q1, weight)
