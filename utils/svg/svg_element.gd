extends Node
class_name SvgElement


var attrs: Dictionary


func _init(attributes: Dictionary) -> void:
	attrs = attributes
	

func collect_pathes() -> Array[SvgPath]:
	var result: Array[SvgPath] = []
	for child in get_children():
		if child is SvgPath:
			result.append(child)
		elif child is SvgElement:
			result.append_array(child.collect_pathes())
	return result
