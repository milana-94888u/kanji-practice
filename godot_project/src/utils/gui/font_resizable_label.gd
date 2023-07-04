extends Label
class_name FontResizableLabel


func _on_resized() -> void:
	add_theme_font_size_override("font_size", int(0.6 * size.y))
