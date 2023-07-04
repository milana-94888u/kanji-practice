extends SubViewport

const MIN_DISTANCE_BETWEEN_POINTS := 0.05
const MAX_VALID_DISTANCE_TO_HALF_PERIMETER_RATIO := 0.1
var max_valid_distance: float

var real_strokes: Array[SvgPath]
var current_stroke := 0

@onready var line_to_draw_with := $LineToDrawWith
var is_drawing := false
var drawing_line: Line2D


func _ready() -> void:
	var svg := SvgParser.parse(
		"res://assets/kanji/%05x.svg" % LoadedKanjiInfo.current_kanji.unicode_at(0)
	)
	size_2d_override = svg.viewbox.size
	
	real_strokes = svg.collect_paths()
	max_valid_distance = (svg.viewbox.size.x + svg.viewbox.size.y) * MAX_VALID_DISTANCE_TO_HALF_PERIMETER_RATIO
	line_to_draw_with.width = 0.15 * max_valid_distance


func _start_line(click_position: Vector2) -> void:
	if click_position.distance_to(real_strokes[current_stroke].position) > max_valid_distance:
		return
	is_drawing = true
	drawing_line = line_to_draw_with.duplicate()
	drawing_line.add_point(click_position)
	add_child(drawing_line)


func _extend_line(mouse_position: Vector2) -> void:
	if is_drawing and mouse_position.distance_to(drawing_line.points[-1]) > MIN_DISTANCE_BETWEEN_POINTS:
		drawing_line.add_point(mouse_position)


func _end_line(_mouse_position: Vector2) -> void:
	if not is_drawing:
		return
	is_drawing = false
	var real_line := real_strokes[current_stroke].draw(drawing_line.get_point_count(), line_to_draw_with.duplicate())
	var distance := _calc_curves_distance(drawing_line, real_line)
	remove_child(drawing_line)
	if distance > max_valid_distance or is_nan(distance):
		return
	add_child(real_line)
	
	current_stroke += 1
	if current_stroke == real_strokes.size():
		get_tree().change_scene_to_file("res://src/level_select/level_select.tscn")



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			_start_line(event.position)
		else:
			_end_line(event.position)
	elif event is InputEventMouseMotion:
		_extend_line(event.position)


# TODO: improve distance calc (Frechet distance, scaled from ends, etc.)
func _calc_curves_distance(left_curve: Line2D, right_curve: Line2D) -> float:
	if left_curve.get_point_count() != right_curve.get_point_count() or left_curve.get_point_count() == 1:
		return NAN
	var squared_distance_sum := 0.0
	for idx in left_curve.get_point_count():
		squared_distance_sum += left_curve.get_point_position(
			idx
		).distance_squared_to(
			right_curve.get_point_position(idx)
		)
	return sqrt(squared_distance_sum / left_curve.get_point_count())
