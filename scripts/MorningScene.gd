extends Node
# Phase 2 will flesh this out into the full greenhouse minigame.
# For now: shows day info, plant status list, and advances phase.

var _action_lbl: Label

func _ready() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 1
	add_child(layer)

	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.10, 0.06)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(bg)

	var root := VBoxContainer.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 60; root.offset_right  = -60
	root.offset_top  = 40; root.offset_bottom = -40
	root.add_theme_constant_override("separation", 16)
	layer.add_child(root)

	var header := _lbl("Day %d  —  Morning" % GameState.day, 28, Color(0.78, 0.92, 0.62))
	root.add_child(header)

	var sub := _lbl("The greenhouse needs attention.", 15, Color(0.55, 0.68, 0.48))
	root.add_child(sub)

	root.add_child(HSeparator.new())

	# Plant status list (stub)
	for p: Dictionary in GameState.plant_states:
		if p["species"] == "":
			root.add_child(_lbl("Plot %d — empty" % p["plot_id"], 14, Color(0.40, 0.45, 0.38)))
		else:
			var spec: Dictionary = PlantData.get_species(p["species"])
			var stage_names := ["Seed", "Sprout", "Mature", "Ready to harvest", "Overripe", "Dead"]
			var stage: int = p["growth_stage"]
			var stage_name: String = stage_names[stage] if stage < stage_names.size() else "Unknown"
			var water_pct := int(p["water_level"] * 100)
			var pest_tag := "  [PEST]" if p["has_pest"] else ""
			var blight_tag := "  [BLIGHT]" if p["has_blight"] else ""
			var col := Color(0.45, 0.55, 0.35) if stage < 5 else Color(0.55, 0.35, 0.35)
			root.add_child(_lbl("Plot %d — %s  |  %s  |  Water: %d%%%s%s" % [
				p["plot_id"], spec.get("name", p["species"]), stage_name, water_pct, pest_tag, blight_tag
			], 14, col))

	_action_lbl = _lbl("Actions remaining: %d" % GameState.actions_left, 15, Color(0.80, 0.85, 0.60))
	root.add_child(_action_lbl)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(spacer)

	var inv_lbl := _lbl(_inventory_text(), 13, Color(0.65, 0.72, 0.50))
	root.add_child(inv_lbl)

	var open_btn := Button.new()
	open_btn.text = "Open the Shop"
	open_btn.custom_minimum_size = Vector2(220, 52)
	open_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	open_btn.add_theme_font_size_override("font_size", 17)
	open_btn.pressed.connect(_on_continue)
	root.add_child(open_btn)

func _on_continue() -> void:
	GameState.save()
	GameState.advance_phase()
	SceneManager.go_to_phase()

func _inventory_text() -> String:
	if GameState.inventory.is_empty():
		return "Inventory: empty"
	var parts: Array[String] = []
	for k: String in GameState.inventory:
		parts.append("%s ×%d" % [k.replace("_", " ").capitalize(), GameState.inventory[k]])
	return "Inventory: " + "  |  ".join(parts)

func _lbl(text: String, size: int, col: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	return l
