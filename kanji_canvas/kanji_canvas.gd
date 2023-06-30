extends Node2D


var active_line: SvgDrawLine
var is_drawing := false


func _ready() -> void:
	var svg := SvgParser.parse("052d5.svg")
	for line in svg.draw_svg(Rect2(300, 100, 500, 500)):
		add_child(line)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			is_drawing = true
			active_line = SvgDrawLine.new()
			add_child(active_line)
		else:
			is_drawing = false
	elif event is InputEventMouseMotion:
		if is_drawing:
			active_line.add_point(event.position)
