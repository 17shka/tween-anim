class_name NodeUtils

## Возвращает узел, на который указывает object
static func get_node_from_path(node_path: NodePath, root: Node = null) -> Node:
	if node_path.is_empty():
		return null

	# Если передан root — ищем от него
	if root:
		return root.get_node_or_null(node_path)

	# Если в редакторе, попробуем получить корень открытой сцены
	if Engine.is_editor_hint():
		var editor_iface := Engine.get_main_loop()
		if editor_iface and editor_iface.has_method("get_edited_scene_root"):
			var scene_root: Node = editor_iface.get_edited_scene_root()
			if scene_root:
				return scene_root.get_node_or_null(node_path)
		return null

	# Если в игре, попробуем получить активную сцену
	var scene_tree := Engine.get_main_loop()
	if scene_tree and scene_tree is SceneTree:
		var current_scene: Node = scene_tree.current_scene
		if current_scene:
			return current_scene.get_node_or_null(node_path)

	return null
