extends Node2D


const MAX_VALID_DISTANCE := 30


var svg_viewbox: Rect2
var svg_pathes: Array[SvgPath]
var current_path := 0
var next_point: Vector2

var draw_viewbox: Rect2

var active_line: SvgDrawLine
var is_drawing := false


func _ready() -> void:
	var svg := SvgParser.parse("res://052d5.svg")
	svg_viewbox = svg.viewbox
	svg_pathes = svg.collect_pathes()
	
	draw_viewbox = Rect2(300, 100, 400, 400)
	_calc_next_point()


func _calc_next_point() -> void:
	next_point = SvgVeiwboxScaleTransformer.new(
		svg_viewbox, draw_viewbox
	).transform_point(
		svg_pathes[current_path].position
	)


func _draw() -> void:
	draw_rect(draw_viewbox, Color.WHEAT)
	draw_circle(next_point, 30, Color.REBECCA_PURPLE)


func _start_line(click_position: Vector2) -> void:
	if click_position.distance_to(next_point) > MAX_VALID_DISTANCE:
		return
	is_drawing = true
	active_line = SvgDrawLine.new()
	active_line.add_point(click_position)
	add_child(active_line)


func _extend_line(mouse_position: Vector2) -> void:
	if is_drawing and mouse_position.distance_to(active_line.points[-1]) > 0.1:
		active_line.add_point(mouse_position)


func _end_line(_mouse_position: Vector2) -> void:
	if not is_drawing:
		return
	is_drawing = false
	var real_line := svg_pathes[current_path].draw(
		svg_viewbox, draw_viewbox, active_line.get_point_count()
	)
	var distance := _calc_curves_distance(active_line, real_line)
	remove_child(active_line)
	if distance > MAX_VALID_DISTANCE or is_nan(distance):
		return
	add_child(real_line)
	
	current_path += 1
	if current_path == svg_pathes.size():
		queue_free()
	else:
		_calc_next_point()
		queue_redraw()


# TODO: fast Frechet distance
func _calc_curves_distance(left_curve: Line2D, right_curve: Line2D) -> float:
	if left_curve.get_point_count() != right_curve.get_point_count():
		return NAN
	var squared_distance_sum := 0.0
	for idx in left_curve.get_point_count():
		squared_distance_sum += left_curve.get_point_position(
			idx
		).distance_squared_to(
			right_curve.get_point_position(idx)
		)
	return sqrt(squared_distance_sum / left_curve.get_point_count())


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			_start_line(event.position)
		else:
			_end_line(event.position)
	elif event is InputEventMouseMotion:
		_extend_line(event.position)
