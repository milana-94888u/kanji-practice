extends Node
class_name SvgElement


var attrs: Dictionary


func _init(attributes: Dictionary) -> void:
	attrs = attributes
	

func draw(initial_viewbox: Rect2, scale_viewbox: Rect2) -> Array[SvgDrawLine]:
	var result: Array[SvgDrawLine] = []
	for child in get_children():
		result.append_array(child.draw(initial_viewbox, scale_viewbox))
	return result
