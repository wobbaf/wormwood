extends Node
# Phase 5 will add narrative beats, journal pages, clickable objects.
# For now: inventory summary, coin, and advances phase.

func _ready() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 1
	add_child(layer)

	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.05, 0.08)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(bg)

	var root := VBoxContainer.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 60; root.offset_right  = -60
	root.offset_top  = 40; root.offset_bottom = -40
	root.add_theme_constant_override("separation", 16)
	layer.add_child(root)

	root.add_child(_lbl("Day %d  —  Evening" % GameState.day, 28, Color(0.72, 0.65, 0.88)))
	root.add_child(_lbl("Coin: %d" % GameState.coin, 17, Color(0.90, 0.82, 0.40)))
	root.add_child(HSeparator.new())

	# Inventory
	if GameState.inventory.is_empty():
		root.add_child(_lbl("Ingredients: none", 14, Color(0.55, 0.52, 0.60)))
	else:
		for k: String in GameState.inventory:
			root.add_child(_lbl("%s  ×%d" % [k.replace("_", " ").capitalize(), GameState.inventory[k]], 14, Color(0.75, 0.78, 0.60)))

	root.add_child(HSeparator.new())
	root.add_child(_lbl("Grandma's desk is cluttered. Something to read here soon. (Phase 5)", 14, Color(0.50, 0.48, 0.55)))

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(spacer)

	var sleep_btn := Button.new()
	sleep_btn.text = "Retire for the Night"
	sleep_btn.custom_minimum_size = Vector2(220, 52)
	sleep_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	sleep_btn.add_theme_font_size_override("font_size", 17)
	sleep_btn.pressed.connect(_on_continue)
	root.add_child(sleep_btn)

func _on_continue() -> void:
	GameState.save()
	GameState.advance_phase()
	SceneManager.go_to_phase()

func _lbl(text: String, size: int, col: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	return l
