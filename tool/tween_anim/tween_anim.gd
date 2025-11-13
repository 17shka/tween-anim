class_name TweenAnim


static func create(template: TweenResource) -> Tween:
	var tween := TweenAnim.create_tween(NodeUtils.get_node_from_path(template.object), template.settings)

	if tween:
		for property in template.property:
			if property is TweenProperty:
				if not property.object:
					property.object = template.object
				
				TweenAnim.create_property(tween, property)

			elif property is TweenCallback:
				if not property.object:
					property.object = template.object
				
				TweenAnim.create_callback(tween, property)

			elif property is TweenMethod:
				if not property.object:
					property.object = template.object
				
				TweenAnim.create_method(tween, property)

			## subtwin
			elif property is TweenResource: 
				if not property.object:
					property.object = template.object
				tween.tween_subtween(create(property))

			elif property is TweenDelay:
				tween.tween_interval(property.delay)

			elif property is TweenSettings:
				template.settings = property
				tween = TweenAnim.create_tween(NodeUtils.get_node_from_path(template.object), template.settings)

		return tween
	return null


static func create_tween(node: Node, settings: TweenSettings = null, tween: Tween = null) -> Tween:
	if not node:
		push_error("Node is null!")
		return
	elif node.get_class() == "CanvasItem":
		push_error("CanvasItem is abstract. Use a subclass (e.g. Node2D or Control).")
		return
	elif not settings:
		settings = TweenSettings.new()

	var meta := settings.meta
	# Проверяем, есть ли уже активный tween
	if meta and node.has_meta(meta):
		var existing_tween: Tween = node.get_meta(meta)
		if existing_tween.is_running():
			match settings.active_tween_action:
				settings.ActiveTweenAction.STOP:
					existing_tween.stop()
				settings.ActiveTweenAction.IGNORE:
					return null
		else:
			node.remove_meta(meta)

	if not tween:
		tween = node.create_tween()

	if meta:
		node.set_meta(meta, tween)
		# Удаляем метаданные после завершения анимации
		tween.finished.connect(func():
			if node.has_meta(meta):
				node.remove_meta(meta)
		)

	if settings.enable_easing:
		tween.set_trans(settings.trans)
		tween.set_ease(settings.ease)
	
	tween.set_loops(settings.loops)
	tween.set_parallel(settings.parallel)
	tween.set_speed_scale(settings.speed_scale)
	
	tween.set_ignore_time_scale(settings.ignore_time_scale)
	tween.set_pause_mode(settings.pause_mode)
	tween.set_process_mode(settings.process_mode)
	
	tween.tween_interval(settings.delay)
	
	return tween


static func create_property(tween: Tween, property: TweenProperty) -> void:
	if not tween:
		push_error("Tween is null!")
	if property == null:
		push_error("TweenProperty is null!")
		return

	if property.parallel:
		tween.parallel()

	var tp := tween.tween_property(NodeUtils.get_node_from_path(property.object), property.property, property.final_val, property.duration)

	if property.delay != 0:
		tp.set_delay(property.delay)
	if property.as_relative:
		tp.as_relative()
	if property.from:
		tp.from(property.from)
	if property.from_current:
		tp.from_current()
	if property.enable_easing:
		tp.set_ease(property.ease)
		tp.set_trans(property.trans)


static func create_callback(tween: Tween, property: TweenCallback) -> void:
	if not tween:
		push_error("Tween is null!")
	if property == null:
		push_error("TweenProperty is null!")
		return
	if not property.method:
		push_error("Empty method!")
		return

	if property.parallel:
		tween.parallel()

	var callable := Callable(NodeUtils.get_node_from_path(property.object), property.method)
	if not property.bind.is_empty():
		callable = callable.bindv(property.bind)
	var tp := tween.tween_callback(callable)

	if property.delay != 0:
		tp.set_delay(property.delay)


static func create_method(tween: Tween, property: TweenMethod) -> void:
	if not tween:
		push_error("Tween is null!")
		return
	if property == null:
		push_error("TweenMethod is null!")
		return
	if not property.method:
		push_error("Empty method!")
		return

	if property.parallel:
		tween.parallel()

	var callable := Callable(NodeUtils.get_node_from_path(property.object), property.method)
	if not property.bind.is_empty():
		callable = callable.bindv(property.bind)

	var tm := tween.tween_method(callable, property.from, property.to, property.duration)

	if property.delay != 0:
		tm.set_delay(property.delay)
	if property.enable_easing:
		tm.set_trans(property.trans)
		tm.set_ease(property.ease)
