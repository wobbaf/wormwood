extends Node
# Phase 3 will flesh this out into the full customer/diagnosis/mixing loop.
# For now: shows coin, stub customer list, and advances phase.

func _ready() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 1
	add_child(layer)

	var bg := ColorRect.new()
	bg.color = Color(0.09, 0.07, 0.05)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(bg)

	var root := VBoxContainer.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 60; root.offset_right  = -60
	root.offset_top  = 40; root.offset_bottom = -40
	root.add_theme_constant_override("separation", 16)
	layer.add_child(root)

	root.add_child(_lbl("Day %d  —  The Shop" % GameState.day, 28, Color(0.92, 0.85, 0.65)))
	root.add_child(_lbl("Coin: %d" % GameState.coin, 17, Color(0.90, 0.82, 0.40)))
	root.add_child(HSeparator.new())
	root.add_child(_lbl("Customers will arrive here. (Phase 3)", 15, Color(0.55, 0.52, 0.45)))

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(spacer)

	var close_btn := Button.new()
	close_btn.text = "Close the Shop"
	close_btn.custom_minimum_size = Vector2(220, 52)
	close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	close_btn.add_theme_font_size_override("font_size", 17)
	close_btn.pressed.connect(_on_continue)
	root.add_child(close_btn)

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
