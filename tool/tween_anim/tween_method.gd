extends TweenDelay
class_name TweenMethod

@export var method: StringName
@export var bind : Array[Variant]
@export var from: Variant
@export var to: Variant
@export_range(0, 10, 0.1, "or_greater") var duration: float

@export_group("Easing")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var enable_easing: bool
@export var trans: Tween.TransitionType
@export var ease: Tween.EaseType
