extends SubViewport


@onready var line_to_draw_with := $LineToDrawWith


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transparent_bg = true
	var all_codes: Array[int]
	for code in (DirAccess.get_files_at("res://assets/kanji") as Array).filter(
		func(filename: String) -> bool:
			return filename.ends_with(".svg")
	).map(
		func(filename: String) -> int:
			return filename.split(".")[0].hex_to_int()
	):
		all_codes.append(code as int)
	all_codes.sort()
	
	size = Vector2.ONE * 109 * 83
	for i in len(all_codes):
		var code := all_codes[i]
		var kanji_node := Node2D.new()
		var offset := Vector2i(i % 83, i / 83) * 109
		kanji_node.position = offset
		fill_kanji_node(kanji_node, code)
		add_child(kanji_node)
	print("meow")


func fill_kanji_node(kanji_node: Node2D, code: int) -> void:
	var svg := SvgParser.parse(
		"res://assets/kanji/%05x.svg" % code
	)
	for path in svg.collect_paths():
		kanji_node.add_child(path.draw(40, line_to_draw_with.duplicate()))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print("Saving")
		var img = get_texture().get_image()
		img.save_png("res://bmpfont.png")
