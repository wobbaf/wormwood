extends Node

# ── Constants ─────────────────────────────────────────────────────────────────

const PLANT_SHEET  := "res://assets/plants/plants_sheet.png"
const SPRITE_W     := 12
const SPRITE_H     := 24
const PLOT_SCALE   := 3   # render sprites at 3× (36×72px)
const GRID_COLS    := 3
const GRID_ROWS    := 2

# Index in the single-row spritesheet (0-indexed, each cell 12px wide)
const SPECIES_SPRITE_IDX := {
	"thornroot":  44,
	"hearthbloom": 8,
	"wormwood":   36,
	"moonleaf":   62,
}

# Tint per growth stage
const STAGE_TINT := [
	Color(0.60, 0.45, 0.30),  # 0 seed      — brown
	Color(0.55, 0.85, 0.45),  # 1 sprout     — bright green
	Color(0.35, 0.72, 0.35),  # 2 mature     — deep green
	Color(0.90, 0.88, 0.30),  # 3 ready      — golden
	Color(0.75, 0.68, 0.22),  # 4 overripe   — dull gold
	Color(0.40, 0.38, 0.35),  # 5 dead       — grey
]

const STAGE_NAMES := ["Seed", "Sprout", "Mature", "Ready to harvest", "Overripe", "Dead"]

const ACTION_COST := {
	"water":   1,
	"prune":   1,
	"inspect": 0,
	"harvest": 1,
	"treat":   1,
}

# ── State ─────────────────────────────────────────────────────────────────────

var _sheet: Texture2D
var _selected: int  = -1
var _plot_nodes: Array[Control] = []
var _info_root: VBoxContainer
var _action_lbl: Label
var _inv_lbl: Label
var _action_btns: Dictionary = {}   # action_name → Button

# ── Build ─────────────────────────────────────────────────────────────────────

func _ready() -> void:
	_sheet = load(PLANT_SHEET)

	var layer := CanvasLayer.new()
	layer.layer = 1
	add_child(layer)

	# Background
	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.09, 0.05)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(bg)

	# Root layout: VBox (header / content / footer)
	var vroot := VBoxContainer.new()
	vroot.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vroot.offset_left = 20; vroot.offset_right  = -20
	vroot.offset_top  = 16; vroot.offset_bottom = -16
	vroot.add_theme_constant_override("separation", 12)
	layer.add_child(vroot)

	# Header
	var hdr := HBoxContainer.new()
	hdr.add_theme_constant_override("separation", 0)
	vroot.add_child(hdr)

	var title := _lbl("Day %d  —  The Greenhouse" % GameState.day, 26, Color(0.75, 0.92, 0.58))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hdr.add_child(title)

	_action_lbl = _lbl("Actions: %d / %d" % [GameState.actions_left, GameState.MORNING_ACTIONS], 18, Color(0.85, 0.90, 0.55))
	hdr.add_child(_action_lbl)

	vroot.add_child(HSeparator.new())

	# Content row: grid left, details right
	var content := HBoxContainer.new()
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 16)
	vroot.add_child(content)

	_build_plot_grid(content)
	_build_info_panel(content)

	vroot.add_child(HSeparator.new())

	# Footer
	var footer := HBoxContainer.new()
	footer.add_theme_constant_override("separation", 0)
	vroot.add_child(footer)

	_inv_lbl = _lbl(_inv_text(), 13, Color(0.65, 0.72, 0.50))
	_inv_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer.add_child(_inv_lbl)

	var open_btn := Button.new()
	open_btn.text = "Open the Shop  ➜"
	open_btn.custom_minimum_size = Vector2(200, 44)
	open_btn.add_theme_font_size_override("font_size", 16)
	open_btn.pressed.connect(_on_open_shop)
	footer.add_child(open_btn)

	# Select first occupied plot by default
	for i in GameState.plant_states.size():
		if GameState.plant_states[i]["species"] != "":
			_select_plot(i)
			break

func _build_plot_grid(parent: Control) -> void:
	var grid_wrap := VBoxContainer.new()
	grid_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid_wrap.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	grid_wrap.add_theme_constant_override("separation", 10)
	parent.add_child(grid_wrap)

	var grid := GridContainer.new()
	grid.columns = GRID_COLS
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	grid.size_flags_vertical   = Control.SIZE_SHRINK_CENTER
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	grid_wrap.add_child(grid)

	_plot_nodes.clear()
	for i in GameState.plant_states.size():
		var cell := _make_plot_cell(i)
		grid.add_child(cell)
		_plot_nodes.append(cell)

func _make_plot_cell(plot_id: int) -> Control:
	var p: Dictionary = GameState.plant_states[plot_id]

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(190, 180)

	var sty := StyleBoxFlat.new()
	sty.bg_color = Color(0.14, 0.11, 0.07)
	sty.border_color = Color(0.30, 0.25, 0.18)
	sty.set_border_width_all(2)
	sty.set_corner_radius_all(6)
	sty.content_margin_left   = 10
	sty.content_margin_right  = 10
	sty.content_margin_top    = 10
	sty.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel", sty)

	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 6)
	panel.add_child(vb)

	# Sprite area
	var sprite_area := Control.new()
	sprite_area.custom_minimum_size = Vector2(SPRITE_W * PLOT_SCALE, SPRITE_H * PLOT_SCALE)
	sprite_area.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vb.add_child(sprite_area)

	if p["species"] != "" and _sheet != null:
		var idx: int = SPECIES_SPRITE_IDX.get(p["species"], 0)
		var stage: int = p["growth_stage"]
		var atlas := AtlasTexture.new()
		atlas.atlas  = _sheet
		atlas.region = Rect2(idx * SPRITE_W, 0, SPRITE_W, SPRITE_H)
		var tr := TextureRect.new()
		tr.texture  = atlas
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.custom_minimum_size = Vector2(SPRITE_W * PLOT_SCALE, SPRITE_H * PLOT_SCALE)
		tr.modulate = STAGE_TINT[stage] if stage < STAGE_TINT.size() else Color.WHITE
		tr.name = "Sprite"
		sprite_area.add_child(tr)
		tr.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	else:
		var empty_lbl := _lbl("Empty", 13, Color(0.40, 0.42, 0.35))
		empty_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sprite_area.add_child(empty_lbl)
		empty_lbl.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# Species + stage label
	var name_str := ""
	if p["species"] != "":
		var spec: Dictionary = PlantData.get_species(p["species"])
		name_str = spec.get("name", p["species"])
		var stage: int = p["growth_stage"]
		var stage_name := STAGE_NAMES[stage] if stage < STAGE_NAMES.size() else ""
		var name_lbl := _lbl(name_str, 12, Color(0.80, 0.88, 0.65))
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vb.add_child(name_lbl)
		var stage_lbl := _lbl(stage_name, 11, Color(0.60, 0.68, 0.50))
		stage_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vb.add_child(stage_lbl)

	# Water bar
	if p["species"] != "":
		vb.add_child(_bar(p["water_level"], Color(0.25, 0.55, 0.88), Color(0.15, 0.18, 0.22), "Water"))
		vb.add_child(_bar(p["health"],      Color(0.35, 0.78, 0.35), Color(0.22, 0.18, 0.15), "Health"))

	# Pest / blight badge
	if p.get("has_pest", false) or p.get("has_blight", false):
		var warn := _lbl("⚠ " + ("PEST" if p["has_pest"] else "BLIGHT"), 11, Color(0.95, 0.55, 0.20))
		warn.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vb.add_child(warn)

	# Click → select
	var btn := Button.new()
	btn.flat = true
	btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	btn.modulate = Color(1, 1, 1, 0)
	btn.pressed.connect(_select_plot.bind(plot_id))
	panel.add_child(btn)

	return panel

func _bar(value: float, fill_col: Color, bg_col: Color, label: String) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)

	var lbl := _lbl(label, 10, Color(0.60, 0.62, 0.55))
	lbl.custom_minimum_size = Vector2(40, 0)
	row.add_child(lbl)

	var track := PanelContainer.new()
	track.custom_minimum_size = Vector2(0, 10)
	track.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var tsty := StyleBoxFlat.new()
	tsty.bg_color = bg_col
	tsty.set_corner_radius_all(3)
	track.add_theme_stylebox_override("panel", tsty)

	var fill := ColorRect.new()
	fill.color = fill_col
	fill.anchor_left   = 0.0
	fill.anchor_top    = 0.0
	fill.anchor_bottom = 1.0
	fill.anchor_right  = clampf(value, 0.0, 1.0)
	fill.offset_left   = 0; fill.offset_right  = 0
	fill.offset_top    = 0; fill.offset_bottom = 0
	track.add_child(fill)
	row.add_child(track)

	return row

func _build_info_panel(parent: Control) -> void:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(280, 0)
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var sty := StyleBoxFlat.new()
	sty.bg_color = Color(0.09, 0.12, 0.07)
	sty.border_color = Color(0.28, 0.35, 0.20)
	sty.set_border_width_all(1)
	sty.set_corner_radius_all(6)
	sty.content_margin_left = 16; sty.content_margin_right  = 16
	sty.content_margin_top  = 16; sty.content_margin_bottom = 16
	panel.add_theme_stylebox_override("panel", sty)

	_info_root = VBoxContainer.new()
	_info_root.add_theme_constant_override("separation", 10)
	panel.add_child(_info_root)
	parent.add_child(panel)

	_info_root.add_child(_lbl("Select a plot", 15, Color(0.60, 0.68, 0.50)))

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_info_root.add_child(spacer)

	# Action buttons
	for action in ["water", "prune", "inspect", "harvest", "treat"]:
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(0, 38)
		btn.add_theme_font_size_override("font_size", 14)
		btn.pressed.connect(_on_action.bind(action))
		_info_root.add_child(btn)
		_action_btns[action] = btn

	_refresh_action_btns()

# ── Selection ─────────────────────────────────────────────────────────────────

func _select_plot(plot_id: int) -> void:
	_selected = plot_id

	# Highlight border
	for i in _plot_nodes.size():
		var pn := _plot_nodes[i]
		var sty := pn.get_theme_stylebox("panel") as StyleBoxFlat
		if sty:
			sty.border_color = Color(0.75, 0.92, 0.40) if i == plot_id else Color(0.30, 0.25, 0.18)
			sty.border_width_left   = 3 if i == plot_id else 2
			sty.border_width_right  = 3 if i == plot_id else 2
			sty.border_width_top    = 3 if i == plot_id else 2
			sty.border_width_bottom = 3 if i == plot_id else 2

	_refresh_info_panel()
	_refresh_action_btns()

func _refresh_info_panel() -> void:
	for c in _info_root.get_children():
		c.queue_free()

	var p: Dictionary = GameState.plant_states[_selected]

	if p["species"] == "":
		_info_root.add_child(_lbl("Plot %d" % _selected, 16, Color(0.65, 0.72, 0.55)))
		_info_root.add_child(_lbl("Empty — no plant here.", 13, Color(0.45, 0.50, 0.40)))
		# TODO Phase 6: add "Plant seed" option
	else:
		var spec: Dictionary = PlantData.get_species(p["species"])
		var stage: int = p["growth_stage"]

		_info_root.add_child(_lbl(spec.get("name", p["species"]), 20, Color(0.80, 0.92, 0.60)))
		_info_root.add_child(_lbl(STAGE_NAMES[stage] if stage < STAGE_NAMES.size() else "", 13, Color(0.65, 0.78, 0.50)))
		_info_root.add_child(HSeparator.new())

		var desc := Label.new()
		desc.text = spec.get("description", "")
		desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc.add_theme_font_size_override("font_size", 12)
		desc.add_theme_color_override("font_color", Color(0.70, 0.72, 0.60))
		_info_root.add_child(desc)

		_info_root.add_child(HSeparator.new())
		_info_root.add_child(_lbl("Water:  %d%%" % int(p["water_level"] * 100), 13,
			Color(0.35, 0.65, 0.90) if p["water_level"] > 0.3 else Color(0.90, 0.50, 0.25)))
		_info_root.add_child(_lbl("Health: %d%%" % int(p["health"] * 100), 13,
			Color(0.40, 0.82, 0.40) if p["health"] > 0.5 else Color(0.88, 0.35, 0.35)))

		if p["has_pest"]:
			_info_root.add_child(_lbl("PEST infestation — use Treat", 12, Color(0.95, 0.60, 0.20)))
		if p["has_blight"]:
			_info_root.add_child(_lbl("BLIGHT spreading — use Treat", 12, Color(0.90, 0.30, 0.30)))

		if stage == 3:
			_info_root.add_child(_lbl("Ready to harvest!", 13, Color(0.95, 0.90, 0.30)))

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_info_root.add_child(spacer)

	# Re-add action buttons
	for action in ["water", "prune", "inspect", "harvest", "treat"]:
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(0, 38)
		btn.add_theme_font_size_override("font_size", 14)
		btn.pressed.connect(_on_action.bind(action))
		_info_root.add_child(btn)
		_action_btns[action] = btn

	_refresh_action_btns()

func _refresh_action_btns() -> void:
	if _selected < 0 or _action_btns.is_empty():
		return
	var p: Dictionary = GameState.plant_states[_selected]
	var has_plant := p["species"] != ""
	var stage: int = p["growth_stage"]
	var no_actions := GameState.actions_left <= 0

	_set_btn("water",   "Water (-%d action)" % ACTION_COST["water"],
		has_plant and stage < 5 and p["water_level"] < 0.9 and not no_actions)
	_set_btn("prune",   "Prune (-%d action)" % ACTION_COST["prune"],
		has_plant and stage in [2, 3, 4] and not no_actions)
	_set_btn("inspect", "Inspect (free)",
		has_plant and stage < 5)
	_set_btn("harvest", "Harvest (-%d action)" % ACTION_COST["harvest"],
		has_plant and stage == 3 and not no_actions)
	_set_btn("treat",   "Treat Pest/Blight (-%d action)" % ACTION_COST["treat"],
		has_plant and (p["has_pest"] or p["has_blight"]) and not no_actions)

	_action_lbl.text = "Actions: %d / %d" % [GameState.actions_left, GameState.MORNING_ACTIONS]

func _set_btn(action: String, label: String, enabled: bool) -> void:
	if not _action_btns.has(action):
		return
	var btn: Button = _action_btns[action]
	btn.text = label
	btn.disabled = not enabled

# ── Actions ───────────────────────────────────────────────────────────────────

func _on_action(action: String) -> void:
	if _selected < 0:
		return
	var p: Dictionary = GameState.plant_states[_selected]
	var cost: int = ACTION_COST.get(action, 1)

	match action:
		"water":
			p["water_level"] = minf(1.0, p["water_level"] + 0.55)
			_spend_action(cost, "Watered %s." % _plant_name(p))

		"prune":
			p["health"] = minf(1.0, p["health"] + 0.15)
			_spend_action(cost, "Pruned %s — healthier now." % _plant_name(p))

		"inspect":
			var lines: Array[String] = []
			lines.append("Water: %d%%" % int(p["water_level"] * 100))
			lines.append("Health: %d%%" % int(p["health"] * 100))
			lines.append("Days in stage: %d" % p["days_in_stage"])
			if p["has_pest"]:
				lines.append("Pest infestation detected.")
			if p["has_blight"]:
				lines.append("Blight spreading.")
			_show_toast("\n".join(lines), Color(0.80, 0.88, 0.65))

		"harvest":
			var spec: Dictionary = PlantData.get_species(p["species"])
			var yield_min: int = spec.get("yield_min", 1)
			var yield_max: int = spec.get("yield_max", 3)
			var amount: int = randi_range(yield_min, yield_max)
			var ing: String = spec.get("yield_ingredient", p["species"])
			GameState.add_ingredient(ing, amount)
			p["growth_stage"] = 2  # reset to mature after harvest
			p["days_in_stage"] = 0
			_spend_action(cost, "Harvested %s — got %d %s." % [_plant_name(p), amount, ing.replace("_", " ")])

		"treat":
			p["has_pest"]   = false
			p["has_blight"] = false
			p["health"] = minf(1.0, p["health"] + 0.10)
			_spend_action(cost, "Treated %s — pest/blight cleared." % _plant_name(p))

	_rebuild_plot_cell(_selected)
	_refresh_info_panel()

func _spend_action(cost: int, msg: String) -> void:
	GameState.actions_left = maxi(0, GameState.actions_left - cost)
	_action_lbl.text = "Actions: %d / %d" % [GameState.actions_left, GameState.MORNING_ACTIONS]
	_inv_lbl.text = _inv_text()
	_show_toast(msg, Color(0.75, 0.90, 0.55))

func _rebuild_plot_cell(plot_id: int) -> void:
	var old := _plot_nodes[plot_id]
	var parent := old.get_parent()
	var idx := old.get_index()
	old.queue_free()
	var new_cell := _make_plot_cell(plot_id)
	parent.add_child(new_cell)
	parent.move_child(new_cell, idx)
	_plot_nodes[plot_id] = new_cell
	# Re-apply selection highlight
	if plot_id == _selected:
		var sty := new_cell.get_theme_stylebox("panel") as StyleBoxFlat
		if sty:
			sty.border_color = Color(0.75, 0.92, 0.40)
			sty.set_border_width_all(3)

# ── Toast ─────────────────────────────────────────────────────────────────────

func _show_toast(msg: String, col: Color) -> void:
	var lbl := Label.new()
	lbl.text = msg
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lbl.add_theme_font_size_override("font_size", 14)
	lbl.add_theme_color_override("font_color", col)
	lbl.position = Vector2(320, 580)
	lbl.size = Vector2(500, 80)
	get_node("CanvasLayer").add_child(lbl)
	var tw := create_tween()
	tw.tween_interval(2.0)
	tw.tween_property(lbl, "modulate:a", 0.0, 0.5)
	tw.tween_callback(lbl.queue_free)

# ── Continue ──────────────────────────────────────────────────────────────────

func _on_open_shop() -> void:
	GameState.save()
	GameState.advance_phase()
	SceneManager.go_to_phase()

# ── Helpers ───────────────────────────────────────────────────────────────────

func _plant_name(p: Dictionary) -> String:
	if p["species"] == "":
		return "plot"
	var spec: Dictionary = PlantData.get_species(p["species"])
	return spec.get("name", p["species"])

func _inv_text() -> String:
	if GameState.inventory.is_empty():
		return "Inventory: empty"
	var parts: Array[String] = []
	for k: String in GameState.inventory:
		parts.append("%s ×%d" % [k.replace("_", " ").capitalize(), GameState.inventory[k]])
	return "Inventory: " + "  ·  ".join(parts)

func _lbl(text: String, size: int, col: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	return l
