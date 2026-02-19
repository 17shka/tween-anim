extends Resource
class_name TweenSettings

@export_group("Playback")
@export_range(0, 1024, 1, "or_greater") var loops: int = 1:
	set(v): loops = v; emit_changed()
@export var parallel: bool = false:
	set(v): parallel = v; emit_changed()
@export_range(0.1, 5.0, 0.1) var speed_scale: float = 1.0:
	set(v): speed_scale = v; emit_changed()
@export_range(0, 10, 0.1, "or_greater") var delay: float:
	set(value): delay = value; emit_changed()

@export_group("Easing")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var enable_easing: bool:
	set(v): enable_easing = v; emit_changed()
@export var trans_type: Tween.TransitionType:
	set(v): trans_type = v; emit_changed()
@export var ease_type: Tween.EaseType:
	set(v): ease_type = v; emit_changed()

@export_group("Process")
@export var ignore_time_scale: bool = false:
	set(v): ignore_time_scale = v; emit_changed()
@export var process_mode: Tween.TweenProcessMode = Tween.TWEEN_PROCESS_IDLE:
	set(v): process_mode = v; emit_changed()
@export var pause_mode: Tween.TweenPauseMode = Tween.TWEEN_PAUSE_BOUND:
	set(v): pause_mode = v; emit_changed()

func set_loops(_loops: int = 0) -> void:
	loops = _loops
