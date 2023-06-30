extends SvgPathCommand
class_name SvgPathCommandMove


func _init(position: Vector2, end: Vector2) -> void:
	super._init(position, end)
	length = (end_point - start_point).length()


func point_at(weight: float) -> Vector2:
	return start_point.lerp(end_point, weight)
