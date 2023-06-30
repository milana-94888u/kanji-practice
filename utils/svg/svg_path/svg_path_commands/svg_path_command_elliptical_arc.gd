extends SvgPathCommand
class_name SvgPathCommandEllipticalArc


var radius_x: float
var radius_y: float
var x_rotation: float
var is_large_arc: float
var is_sweep: float


func _init(
	position: Vector2,
	radiuses: Vector2,
	rotation: float,
	large_arc_flag: float,
	sweep_flag: float,
	end: Vector2,
) -> void:
	super._init(position, end)
	radius_x = radiuses.x
	radius_y = radiuses.y
	x_rotation = rotation
	is_large_arc = large_arc_flag
	is_sweep = sweep_flag
