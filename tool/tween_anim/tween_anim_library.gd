class_name TweenAnimLibrary


## Создает эффект тряски
static func shake(node: CanvasItem, value: float = 8, duration: float = 0.1) -> void:
	const SETTINGS = preload("uid://bbgyhio15ktbi")
	var tween := TweenAnim.create_tween(node, SETTINGS)
	if not tween:
		return

	duration *= 0.5
	var base_value : Vector2 = node.position
	var offset := Vector2(randf_range(-value, value), randf_range(-value, value))
	
	tween.tween_property(node, "position", base_value + offset, duration)
	tween.tween_property(node, "position", base_value, duration)

## Создает эффект уменьшения и возврата к норме
static func shrink(node: CanvasItem, value: float = 1.2, duration: float = 0.2) -> void:
	const SETTINGS = preload("uid://cl0x06shdpeay")
	var tween := TweenAnim.create_tween(node, SETTINGS)
	if not tween:
		return

	duration *= 0.5
	var base_value : Vector2 = node.scale
	var target_scale := base_value * value

	tween.tween_property(node, "scale", target_scale, duration)
	tween.tween_property(node, "scale", base_value, duration)


static func scaling(node: CanvasItem, value: float = 1.2, duration: float = 1) -> void:
	const SETTINGS = preload("uid://bxgi27fkyxqcr")
	var tween := TweenAnim.create_tween(node, SETTINGS)
	if not tween:
		return

	duration *= 0.5
	var base_value : Vector2 = node.scale
	var target_scale := base_value * value

	# плавное увеличение и уменьшение
	tween.tween_property(node, "scale", target_scale, duration)
	tween.tween_property(node, "scale", base_value, duration)

## Плавное изменение прозрачности с повторным использованием Tween
static func fade(node: CanvasItem, target_alpha: float, duration: float = 0) -> void:
	const SETTINGS = preload("uid://otqg3tk3det3")
	var tween := TweenAnim.create_tween(node, SETTINGS)
	if not tween:
		return

	# Вычисляем длительность пропорционально разнице
	if duration <= 0:
		duration = abs(target_alpha - node.modulate.a) * 0.5
		duration = clamp(duration, 0.1, 0.5)

	tween.tween_property(node, "modulate:a", target_alpha, duration)
