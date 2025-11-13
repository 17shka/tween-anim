@abstract
extends Resource
class_name TweenTweener

func rename(part: String, value: String) -> void:
	var pattern := part + "[^ ]*"
	var segment := part + value
	var regex := RegEx.create_from_string(pattern)
	var match := regex.search(resource_name)

	if match:
		resource_name = resource_name.substr(0, match.get_start()) + segment + resource_name.substr(match.get_end())
	else:
		resource_name += segment
