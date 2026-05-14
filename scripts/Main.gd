extends Node

func _ready() -> void:
	# Try loading a save; if none, show the title/new game screen
	if GameState.load_save():
		SceneManager.go_to_phase()
	else:
		_show_title()

func _show_title() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 1
	add_child(layer)

	var bg := ColorRect.new()
	bg.color = Color(0.07, 0.06, 0.04)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(bg)

	var root := VBoxContainer.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 0; root.offset_right  = 0
	root.offset_top  = 0; root.offset_bottom = 0
	root.alignment = BoxContainer.ALIGNMENT_CENTER
	root.add_theme_constant_override("separation", 24)
	layer.add_child(root)

	var title := Label.new()
	title.text = "Wormwood"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 52)
	title.add_theme_color_override("font_color", Color(0.78, 0.92, 0.62))
	root.add_child(title)

	var sub := Label.new()
	sub.text = "Your grandmother's shop. Her secrets. Her plants."
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_font_size_override("font_size", 16)
	sub.add_theme_color_override("font_color", Color(0.65, 0.72, 0.55))
	root.add_child(sub)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 32)
	root.add_child(spacer)

	var new_btn := _make_btn("Begin")
	new_btn.pressed.connect(func() -> void:
		layer.queue_free()
		SceneManager.go_to("morning")
	)
	root.add_child(new_btn)

	if FileAccess.file_exists(GameState.SAVE_PATH):
		var load_btn := _make_btn("Continue")
		load_btn.pressed.connect(func() -> void:
			GameState.load_save()
			layer.queue_free()
			SceneManager.go_to_phase()
		)
		root.add_child(load_btn)

	var day_lbl := Label.new()
	day_lbl.text = "Day %d" % GameState.day if FileAccess.file_exists(GameState.SAVE_PATH) else ""
	day_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	day_lbl.add_theme_font_size_override("font_size", 13)
	day_lbl.add_theme_color_override("font_color", Color(0.45, 0.50, 0.38))
	root.add_child(day_lbl)

func _make_btn(label: String) -> Button:
	var btn := Button.new()
	btn.text = label
	btn.custom_minimum_size = Vector2(220, 52)
	btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	btn.add_theme_font_size_override("font_size", 18)
	return btn
