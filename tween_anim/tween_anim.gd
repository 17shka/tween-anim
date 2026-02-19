class_name TweenAnim

const OWNER: StringName = &"owner"
const BASE_VALUE: StringName = &"base_value"
const SETTINGS: StringName = &"settings"
const BASE_PREFIX: StringName = &"tween_"


static func tween_pulse(node: Node, tween: Tween, property: StringName, value: Variant, duration: float, settings: TweenSettings = null) -> Tween:
	duration *= 0.5
	if not tween:
		tween = get_or_create_tween(node, property, settings)
	var base_value: Variant
	if tween.has_meta(BASE_VALUE):
		base_value = tween.get_meta(BASE_VALUE).get(property)
	else:
		var target_property: Variant = node.get(property)
		set_tween_base_value(tween, {property: target_property})
		base_value = target_property
	tween.tween_property(node, property.simplify_path(), value, duration)
	tween.tween_property(node, property.simplify_path(), base_value, duration)
	return tween

## Сбрасывает измененные property tween.owner
static func reset_to_default(tween: Tween) -> bool:
	if tween.has_meta(OWNER) and tween.has_meta(BASE_VALUE):
		var tween_owner: Node = tween.get_meta(OWNER)
		var tween_base_value: Dictionary[StringName, Variant]= tween.get_meta(BASE_VALUE)

		for property: StringName in tween_base_value.keys():
			tween_owner.set_indexed(
				property.simplify_path(),
				tween_base_value[property]
			)

		return true
	return false


static func set_tween_property(tween: Tween, property: StringName, final_val: Variant, duration: float) -> void:
	var node: Node = tween.get_meta(OWNER)
	var path := property.simplify_path()
	tween.tween_property(node, path, final_val, duration)
	set_tween_base_value(tween, {property: node.get_indexed(path)})


static func set_tween_base_value(tween: Tween, value: Dictionary[StringName, Variant]) -> void:
	var base: Dictionary[StringName, Variant]

	if tween.has_meta(BASE_VALUE):
		base = tween.get_meta(BASE_VALUE) as Dictionary[StringName, Variant]

	base.merge(value, true)
	tween.set_meta(BASE_VALUE, base)


static func get_or_create_tween(
	node: Node,
	meta: StringName = &"",
	settings: TweenSettings = null
) -> Tween:
	var tween: Tween = get_tween(node, meta)
	if tween and tween.is_running():
		return reset_tween(tween, meta)

	return create_tween(node, meta, settings)


static func create_tween(node: Node, meta: StringName = &"", settings: TweenSettings = null) -> Tween:
	var tween := node.create_tween()
	register_tween(node, tween, meta)
	if settings:
		set_settings(tween, settings)
	return tween


static func has_tween_meta(node: Node, meta: StringName = &"") -> bool:
	return node.has_meta(BASE_PREFIX + meta)


static func get_tween(node: Node, meta: StringName = &"") -> Tween:
	meta = BASE_PREFIX + meta
	if not node.has_meta(meta):
		return null

	var tween: Tween = node.get_meta(meta)
	if tween and tween.is_valid():
		return tween

	node.remove_meta(meta)
	return null


static func register_tween(node: Node, tween: Tween, meta: StringName = &"") -> void:
	tween.set_meta(OWNER, node)
	if not meta.is_empty():
		meta = BASE_PREFIX + meta
		node.set_meta(meta, tween)
		tween.finished.connect(func() -> void:
			if is_instance_valid(node) and node.has_meta(meta):
				node.remove_meta(meta)
		)

static func reset_tween(tween: Tween, meta: StringName = &"") -> Tween:
	var tween_owner: Node = tween.get_meta(OWNER)
	var new_tween: Tween = create_tween(tween_owner, meta , tween.get_meta(SETTINGS) if tween.has_meta(SETTINGS) else null)
	for tween_meta in tween.get_meta_list():
		if new_tween.has_meta(tween_meta): continue
		new_tween.set_meta(tween_meta, tween.get_meta(tween_meta))

	tween.kill()
	tween_owner.set_meta(meta, new_tween)
	return new_tween


static func remove_tween(node: Node, meta: StringName = node.name, return_to_default: bool = false) -> bool:
	meta = BASE_PREFIX + meta

	if not node.has_meta(meta):
		return false
	if return_to_default:
		var tween: Tween = node.get_meta(meta)
		if tween.has_meta(BASE_VALUE):
			var base_value: Dictionary[StringName, Variant] = tween.get_meta(BASE_VALUE)
			for property in base_value:
				node.set(property, base_value.get(property))
	else:
		node.get_meta(meta).kill()

	node.remove_meta(meta)
	return true


static func set_settings(tween: Tween, settings: TweenSettings) -> void:
	if tween.has_meta(SETTINGS): return

	tween.set_meta(SETTINGS, settings)
	ToolNode.set_signal(settings.changed, setup_settings.bind(tween, settings))
	#settings.changed.connect()

	setup_settings(tween, settings)


static func setup_settings(tween: Tween, settings: TweenSettings) -> void:
	if settings.enable_easing:
		tween.set_trans(settings.trans_type)
		tween.set_ease(settings.ease_type)

	tween.set_loops(settings.loops)
	tween.set_parallel(settings.parallel)
	tween.set_speed_scale(settings.speed_scale)

	tween.set_ignore_time_scale(settings.ignore_time_scale)
	tween.set_pause_mode(settings.pause_mode)
	tween.set_process_mode(settings.process_mode)

	tween.tween_interval(settings.delay)
