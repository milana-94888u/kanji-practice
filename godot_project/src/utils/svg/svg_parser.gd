extends Object
class_name SvgParser


static func parse(svg_file_path: String) -> Svg:
	var parser := SvgParser.new(svg_file_path)
	return parser._parse()


var xml_parser: XMLParser


func _init(svg_file_path: String) -> void:
	xml_parser = XMLParser.new()
	xml_parser.open(svg_file_path)


func _get_attrs_dict() -> Dictionary:
	var result := {}
	for idx in xml_parser.get_attribute_count():
		result[xml_parser.get_attribute_name(idx)] = xml_parser.get_attribute_value(idx)
	return result


func _parse() -> SvgElement:
	var opened_elements: Array[String] = []
	var current_element: SvgElement
	while true:
		if xml_parser.read() != OK:
			return
		var node_type := xml_parser.get_node_type()
		if node_type not in [XMLParser.NODE_ELEMENT, XMLParser.NODE_ELEMENT_END]:
			continue
		
		var node_name := xml_parser.get_node_name()
		if node_type == XMLParser.NODE_ELEMENT_END:
			if opened_elements.pop_back() != node_name:
				return null
			if node_name == "g":
				current_element = current_element.get_parent()
			elif node_name == "svg":
				break
			continue
		
		var attributes := _get_attrs_dict()
		match node_name:
			"svg":
				if opened_elements:
					return null
				opened_elements.push_back(node_name)
				current_element = Svg.new(attributes)
			"g":
				opened_elements.push_back(node_name)
				var new_node := SvgElement.new(attributes)
				current_element.add_child(new_node)
				current_element = new_node
			"path":
				current_element.add_child(SvgPath.new(attributes))
			_:
				opened_elements.push_back(node_name)
	return current_element
