extends SvgPathCommand
class_name SvgPathCommandMove


func _init(position: Vector2, end: Vector2) -> void:
	super._init(position, end)


func point_at(weight: float) -> Vector2:
	return start_point.lerp(end_point, weight)
