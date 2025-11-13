extends TweenTweener
class_name TweenResource

@export var object: NodePath
@export var settings: TweenSettings
@export var property: Array[TweenTweener]

func create(template: TweenResource = self) -> Tween:
	return TweenAnim.create(template)
