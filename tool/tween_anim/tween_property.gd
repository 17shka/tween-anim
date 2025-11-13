@tool
extends TweenDelay
class_name TweenProperty

@export var object: NodePath

@export var property: String:
	set(value):
		property = value
		_rename()

@export var final_val: Variant:
	set(value):
		final_val = value
		_rename()

@export_range(0.1, 5, 0.1, "or_greater") var duration: float = 1.0:
	set(value):
		duration = value
		rename("t: ", str(value))

@export var parallel: bool

@export_group("PropertyTweener")
@export var as_relative: bool
@export var from: Variant
@export var from_current: bool

@export_group("Easing")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var enable_easing: bool
@export var trans: Tween.TransitionType
@export var ease: Tween.EaseType

func _rename() -> void:
	resource_name = property + str(final_val)
	rename(" t: ", str(duration))
	
