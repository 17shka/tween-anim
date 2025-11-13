extends TweenDelay
class_name TweenSettings

@export var meta: StringName

@export_group("Playback")
enum ActiveTweenAction {STOP, IGNORE }
@export var active_tween_action: ActiveTweenAction = ActiveTweenAction.STOP
# Number of animation loops. 0 = infinite
@export_range(0, 1024, 1, "or_greater") var loops: int = 1
@export var parallel: bool = false
@export_range(0.1, 5.0, 0.1) var speed_scale: float = 1.0

@export_group("Easing")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var enable_easing: bool
@export var trans: Tween.TransitionType
@export var ease: Tween.EaseType

@export_group("Process")
@export var ignore_time_scale: bool = false
@export var process_mode: Tween.TweenProcessMode = Tween.TWEEN_PROCESS_IDLE
@export var pause_mode: Tween.TweenPauseMode = Tween.TWEEN_PAUSE_BOUND

func set_loops(loops: int = 0) -> void:
	loops = loops
