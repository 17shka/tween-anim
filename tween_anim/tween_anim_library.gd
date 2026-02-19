class_name TweenLib


const MOVE_TO_SETTINGS := preload("uid://lmr57prnyshi")
static func move_to(node: CanvasItem, pos: Vector2, duration: float = 0.5) -> Tween:
	var tween := TweenAnim.get_or_create_tween(node, &"move_to", MOVE_TO_SETTINGS)
	if not tween: return
	tween.tween_property(node, "position", pos, duration).from_current()
	return tween


const SHAKE_SETTINGS := preload("uid://bbgyhio15ktbi")
## Тряска
static func shake(node: CanvasItem, value: float = 8, duration: float = 0.1) -> Tween:
	return TweenAnim.tween_pulse(
		node, null, "position",
		node.position + Vector2(randf_range(-value, value), randf_range(-value, value)),
		duration, SHAKE_SETTINGS)


const SHRINK_SETTINGS := preload("uid://cl0x06shdpeay")
## Уменьшения и возврата к норме
static func shrink(node: CanvasItem, value: Vector2 = node.scale * 1.2, duration: float = 0.2) -> Tween:
	return TweenAnim.tween_pulse(node, null, &"scale", value, duration, SHRINK_SETTINGS)


const SCALING_SETTINGS := preload("uid://bxgi27fkyxqcr")
## Цыкличное увеличение и уменьшение
static func scaling(node: CanvasItem, tween: Tween = null, value: Vector2 = node.scale * 1.2, duration: float = 2) -> Tween:
	return TweenAnim.tween_pulse(node, tween, &"scale", value, duration, SCALING_SETTINGS)


const FADE_SETTINGS := preload("uid://otqg3tk3det3")
## Плавное изменение прозрачности
static func fade(node: CanvasItem, target_alpha: float, duration: float = 0.5, change_visible: bool = true) -> Tween:
	var tween := TweenAnim.get_or_create_tween(node,  &"fade", FADE_SETTINGS)
	if duration <= 0:
		duration = absf(target_alpha - node.modulate.a) * 0.5
		duration = clampf(duration, 0.1, 0.5)
	TweenAnim.set_tween_property(tween, &"modulate:a", target_alpha, duration)

	if change_visible:
		_change_visible_to_color(node, tween, Color.WHITE * target_alpha)

	return tween

static func show_on_time(node: CanvasItem, show_time: float = 2, hide_time: float = 1) -> Tween:
	var tween := fade(node, 1, hide_time)
	tween.tween_interval(show_time)
	tween.finished.connect(fade.bind(node, 0, hide_time))
	return tween


const FLASH_COLOR_SETTINGS := preload("uid://cpwk44vvx6yrl")
## Вспышка цветом
static func flash_color(node: CanvasItem, color: Color, duration: float = 0.4) -> Tween:
	return TweenAnim.tween_pulse(node, null, &"modulate", color, duration, FLASH_COLOR_SETTINGS)


static func change_color(node: CanvasItem, color: Color, duration: float = 0.4, change_visible: bool = true) -> Tween:
	var tween := TweenAnim.get_or_create_tween(node, &"change_color")
	tween.tween_property(node, "modulate", color, duration)
	if change_visible:
		_change_visible_to_color(node, tween, color)
	return tween

static func _change_visible_to_color(node: CanvasItem, tween: Tween, color: Color) -> void:
	if color.a > 0.0:
		node.visible = true
	elif node.visible:
		TweenAnim.set_tween_base_value(tween, {&"visible": node.visible})
		tween.finished.connect(func() -> void:
			node.visible = false
		)
