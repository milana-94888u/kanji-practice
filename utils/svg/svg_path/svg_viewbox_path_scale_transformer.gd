extends Object
class_name SvgVeiwboxScaleTransformer


var initial_shift: Vector2
var scale_shift: Vector2

var scale_aspect: Vector2


func _init(initial_viewbox: Rect2, scale_viewbox: Rect2) -> void:
	initial_shift = initial_viewbox.position
	scale_shift = scale_viewbox.position
	scale_aspect = scale_viewbox.size / initial_viewbox.size


func _transform_point(initial_point: Vector2) -> Vector2:
	return (initial_point - initial_shift) * scale_aspect + scale_shift


func transform_line(line: Line2D) -> Line2D:
	for i in line.get_point_count():
		line.set_point_position(i, _transform_point(line.get_point_position(i)))
	return line
