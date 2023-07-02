extends SvgPathCommand
class_name SvgPathCommandCubicCurve


var first_control_point: Vector2
var second_control_point: Vector2


func _init(position: Vector2, first_control: Vector2, second_control: Vector2, end: Vector2) -> void:
	super._init(position, end)
	first_control_point = first_control
	second_control_point = second_control
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
	var q0 := start_point.lerp(first_control_point, weight)
	var q1 := first_control_point.lerp(second_control_point, weight)
	var q2 := second_control_point.lerp(end_point, weight)
	
	var r0 := q0.lerp(q1, weight)
	var r1 := q1.lerp(q2, weight)
	
	return r0.lerp(r1, weight)
