extends Node

signal scene_changed(scene_name: String)

var _current: Node = null
var _root: Node = null

const SCENES := {
	"main":      "res://scenes/Main.tscn",
	"morning":   "res://scenes/MorningScene.tscn",
	"day":       "res://scenes/DayScene.tscn",
	"evening":   "res://scenes/EveningScene.tscn",
	"night":     "res://scenes/NightScene.tscn",
}

func _ready() -> void:
	_root = get_tree().root

func go_to(scene_name: String) -> void:
	if not SCENES.has(scene_name):
		push_error("SceneManager: unknown scene '%s'" % scene_name)
		return
	_swap(load(SCENES[scene_name]))
	scene_changed.emit(scene_name)

func go_to_phase() -> void:
	match GameState.phase:
		GameState.Phase.MORNING: go_to("morning")
		GameState.Phase.DAY:     go_to("day")
		GameState.Phase.EVENING: go_to("evening")
		GameState.Phase.NIGHT:   go_to("night")

func _swap(packed: PackedScene) -> void:
	if _current:
		_current.queue_free()
	_current = packed.instantiate()
	_root.add_child(_current)
