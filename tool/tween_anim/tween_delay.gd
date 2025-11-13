@tool
extends TweenTweener
class_name TweenDelay

@export_range(0, 10, 0.1, "or_greater") var delay: float:
	set(value):
		delay = value
		rename(" d:", str(value))
