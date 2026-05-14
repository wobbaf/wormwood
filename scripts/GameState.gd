extends Node

# ── Enums ─────────────────────────────────────────────────────────────────────

enum Phase { MORNING, DAY, EVENING, NIGHT }

# ── Signals ───────────────────────────────────────────────────────────────────

signal day_changed(new_day: int)
signal phase_changed(new_phase: Phase)
signal inventory_changed
signal coin_changed(new_amount: int)

# ── State ─────────────────────────────────────────────────────────────────────

var day: int = 1
var phase: Phase = Phase.MORNING
var coin: int = 40
var actions_left: int = 5  # morning greenhouse actions per day

var inventory: Dictionary = {}       # ingredient_id → count
var plant_states: Array = []         # Array[Dictionary], one per plot
var story_flags: Dictionary = {}     # flag_id → bool/int/String
var reputation: Dictionary = {       # character_id → int (-100 to 100)
	"lena": 0,
	"voss": 0,
	"brennan": 0,
	"petre": 0,
}
var known_recipes: Array[String] = []   # recipe IDs unlocked
var journal_pages: Array[int] = []      # page numbers found

const SAVE_PATH := "user://savegame.dat"
const MAX_PLOTS := 6
const MORNING_ACTIONS := 5

# ── Init ──────────────────────────────────────────────────────────────────────

func _ready() -> void:
	_init_plants()

func _init_plants() -> void:
	if not plant_states.is_empty():
		return
	# Grandma left 3 plots pre-planted
	plant_states = []
	for i in range(MAX_PLOTS):
		plant_states.append(_empty_plot(i))
	plant_states[0]["species"] = "thornroot"
	plant_states[0]["growth_stage"] = 2  # mature, ready soon
	plant_states[0]["water_level"] = 0.6
	plant_states[1]["species"] = "hearthbloom"
	plant_states[1]["growth_stage"] = 1  # sprout
	plant_states[1]["water_level"] = 0.8
	plant_states[2]["species"] = "wormwood"
	plant_states[2]["growth_stage"] = 1  # sprout
	plant_states[2]["water_level"] = 0.7

func _empty_plot(plot_id: int) -> Dictionary:
	return {
		"plot_id": plot_id,
		"species": "",           # empty = no plant
		"growth_stage": 0,       # 0=seed 1=sprout 2=mature 3=ready 4=overripe 5=dead
		"water_level": 0.0,      # 0.0–1.0
		"health": 1.0,           # 0.0–1.0
		"days_in_stage": 0,
		"has_pest": false,
		"has_blight": false,
	}

# ── Phase management ──────────────────────────────────────────────────────────

func advance_phase() -> void:
	match phase:
		Phase.MORNING:
			phase = Phase.DAY
		Phase.DAY:
			phase = Phase.EVENING
		Phase.EVENING:
			phase = Phase.NIGHT
		Phase.NIGHT:
			_advance_day()
			phase = Phase.MORNING
			actions_left = MORNING_ACTIONS
	phase_changed.emit(phase)

func _advance_day() -> void:
	day += 1
	_tick_plants()
	day_changed.emit(day)

# ── Plant ticking ─────────────────────────────────────────────────────────────

func _tick_plants() -> void:
	for p: Dictionary in plant_states:
		if p["species"] == "":
			continue
		p["days_in_stage"] += 1
		# Water drains daily
		p["water_level"] = maxf(0.0, p["water_level"] - 0.35)
		if p["water_level"] < 0.2:
			p["health"] = maxf(0.0, p["health"] - 0.2)
		# Advance growth stage
		var spec: Dictionary = PlantData.get_species(p["species"])
		var days_needed: int = spec.get("days_per_stage", 2)
		if p["days_in_stage"] >= days_needed and p["growth_stage"] < 5:
			p["growth_stage"] += 1
			p["days_in_stage"] = 0
		# Dead plants have no health
		if p["health"] <= 0.0:
			p["growth_stage"] = 5  # dead
		# Random pest/blight chance
		if p["growth_stage"] in [2, 3] and randf() < 0.08:
			p["has_pest"] = true
		if p["has_pest"] and randf() < 0.3:
			p["health"] = maxf(0.0, p["health"] - 0.15)

# ── Inventory helpers ─────────────────────────────────────────────────────────

func add_ingredient(id: String, amount: int) -> void:
	inventory[id] = inventory.get(id, 0) + amount
	inventory_changed.emit()

func remove_ingredient(id: String, amount: int) -> bool:
	var have: int = inventory.get(id, 0)
	if have < amount:
		return false
	inventory[id] = have - amount
	if inventory[id] == 0:
		inventory.erase(id)
	inventory_changed.emit()
	return true

func has_ingredient(id: String, amount: int = 1) -> bool:
	return inventory.get(id, 0) >= amount

# ── Coin helpers ──────────────────────────────────────────────────────────────

func add_coin(amount: int) -> void:
	coin += amount
	coin_changed.emit(coin)

func spend_coin(amount: int) -> bool:
	if coin < amount:
		return false
	coin -= amount
	coin_changed.emit(coin)
	return true

# ── Story helpers ─────────────────────────────────────────────────────────────

func set_flag(flag: String, value: Variant = true) -> void:
	story_flags[flag] = value

func get_flag(flag: String, default: Variant = false) -> Variant:
	return story_flags.get(flag, default)

func change_reputation(character: String, delta: int) -> void:
	if reputation.has(character):
		reputation[character] = clampi(reputation[character] + delta, -100, 100)

func unlock_recipe(recipe_id: String) -> void:
	if not known_recipes.has(recipe_id):
		known_recipes.append(recipe_id)

func find_journal_page(page: int) -> void:
	if not journal_pages.has(page):
		journal_pages.append(page)
		journal_pages.sort()

# ── Save / Load ───────────────────────────────────────────────────────────────

func save() -> void:
	var data := {
		"day": day,
		"coin": coin,
		"inventory": inventory,
		"plant_states": plant_states,
		"story_flags": story_flags,
		"reputation": reputation,
		"known_recipes": known_recipes,
		"journal_pages": journal_pages,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func load_save() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var text := file.get_as_text()
	file.close()
	var parsed: Variant = JSON.parse_string(text)
	if not parsed is Dictionary:
		return false
	var data: Dictionary = parsed
	day            = data.get("day", 1)
	coin           = data.get("coin", 40)
	inventory      = data.get("inventory", {})
	plant_states   = data.get("plant_states", [])
	story_flags    = data.get("story_flags", {})
	reputation     = data.get("reputation", reputation)
	known_recipes  = data.get("known_recipes", [])
	journal_pages  = data.get("journal_pages", [])
	if plant_states.is_empty():
		_init_plants()
	day_changed.emit(day)
	phase_changed.emit(phase)
	inventory_changed.emit()
	coin_changed.emit(coin)
	return true

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
