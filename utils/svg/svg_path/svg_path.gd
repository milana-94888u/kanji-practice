extends SvgElement
class_name SvgPath


var commands: Array[SvgPathCommand]
var length: float


func _init(attributes: Dictionary) -> void:
	commands = SvgPathParser.parse(attributes.get("d"))
	attributes.erase("d")
	super._init(attributes)

	length = 0.0
	for command in commands:
		length += command.length
	


func draw(initial_viewbox: Rect2, scale_viewbox: Rect2) -> Array[Line2D]:
	var line := SvgDrawLine.new()
	for command in commands:
		line = command.draw(0, line)
	return [SvgVeiwboxScaleTransformer.new(initial_viewbox, scale_viewbox).transform_line(line)]
