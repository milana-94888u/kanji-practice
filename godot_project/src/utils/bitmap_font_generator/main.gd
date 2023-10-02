extends Control


func _ready() -> void:
	$AspectRatioContainer/SubViewportContainer/SubViewport.transparent_bg = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var img = $AspectRatioContainer/SubViewportContainer/SubViewport.get_texture().get_image()
		img.save_png("res://bmpfont_small.png")
