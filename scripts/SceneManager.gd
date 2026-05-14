extends Node

signal scene_changed(scene_name: String)

const SCENES := {
	"main":      "res://scenes/Main.tscn",
	"morning":   "res://scenes/MorningScene.tscn",
	"day":       "res://scenes/DayScene.tscn",
	"evening":   "res://scenes/EveningScene.tscn",
	"night":     "res://scenes/NightScene.tscn",
}

func go_to(scene_name: String) -> void:
	if not SCENES.has(scene_name):
		push_error("SceneManager: unknown scene '%s'" % scene_name)
		return
	get_tree().change_scene_to_packed(load(SCENES[scene_name]))
	scene_changed.emit(scene_name)

func go_to_phase() -> void:
	match GameState.phase:
		GameState.Phase.MORNING: go_to("morning")
		GameState.Phase.DAY:     go_to("day")
		GameState.Phase.EVENING: go_to("evening")
		GameState.Phase.NIGHT:   go_to("night")
