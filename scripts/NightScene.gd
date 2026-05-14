extends Node
# Phase 5 will add the full night event system (letters, knocks, dreams).
# For now: shows a stub night text and advances to next day.

const STUB_EVENTS := [
	"The shop is quiet. Wind moves through the gap under the door.\n\nYou sit at Grandma Elsa's desk for a while. Her handwriting is everywhere.",
	"Somewhere down the street, footsteps. Then silence.\n\nYou should sleep. You don't, not right away.",
	"The locked door to the back greenhouse catches your eye again.\n\nSomething grows in there. You can smell it faintly.",
	"You find a note tucked inside a jar of dried thornroot: 'Don't trust the easy explanation.' Her handwriting.",
]

func _ready() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 1
	add_child(layer)

	var bg := ColorRect.new()
	bg.color = Color(0.03, 0.03, 0.05)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(bg)

	var root := VBoxContainer.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 140; root.offset_right  = -140
	root.offset_top  = 80;  root.offset_bottom = -80
	root.alignment = BoxContainer.ALIGNMENT_CENTER
	root.add_theme_constant_override("separation", 32)
	layer.add_child(root)

	root.add_child(_lbl("Night", 20, Color(0.45, 0.42, 0.58)))

	var idx: int = (GameState.day - 1) % STUB_EVENTS.size()
	var event_lbl := Label.new()
	event_lbl.text = STUB_EVENTS[idx]
	event_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	event_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	event_lbl.add_theme_font_size_override("font_size", 17)
	event_lbl.add_theme_color_override("font_color", Color(0.72, 0.70, 0.80))
	root.add_child(event_lbl)

	var continue_btn := Button.new()
	continue_btn.text = "Sleep"
	continue_btn.custom_minimum_size = Vector2(160, 48)
	continue_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	continue_btn.add_theme_font_size_override("font_size", 16)
	continue_btn.pressed.connect(_on_continue)
	root.add_child(continue_btn)

func _on_continue() -> void:
	GameState.save()
	GameState.advance_phase()  # NIGHT → MORNING, advances day
	SceneManager.go_to_phase()

func _lbl(text: String, size: int, col: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	return l
