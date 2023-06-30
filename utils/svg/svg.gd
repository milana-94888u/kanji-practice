extends SvgElement
class_name Svg


var viewbox: Rect2


func _parse_rect(rect_str: String) -> Rect2:
	var rect_params := rect_str.split(" ")
	return Rect2(float(rect_params[0]), float(rect_params[1]), float(rect_params[2]), float(rect_params[3]))


func _init(attributes: Dictionary) -> void:
	viewbox = _parse_rect(attributes.get("viewBox"))
	attributes.erase("viewBox")
	super._init(attributes)


func draw_svg(scale_viewbox: Rect2) -> Array[SvgDrawLine]:
	var result: Array[SvgDrawLine] = []
	for child in get_children():
		if child is SvgPath:
			result.append(child.draw(viewbox, scale_viewbox))
		elif child is SvgElement:
			result.append_array(child.draw(viewbox, scale_viewbox))
	return result
