extends Node

# Known remedy recipes. Unlocked progressively via journal pages and customer hints.

const RECIPES := {
	"thornroot_tea": {
		"name": "Thornroot Tea",
		"description": "A reliable fever reducer. Grandma's handwriting reads: 'steep twice, no more.'",
		"ingredients": {"thornroot_extract": 2},
		"treats": ["fever", "headache"],
		"potency": 1,
		"unlock_day": 1,  # known from start
	},
	"hearthbloom_tincture": {
		"name": "Hearthbloom Tincture",
		"description": "Calms the nerves. Smells faintly of summer.",
		"ingredients": {"hearthbloom_petals": 1},
		"treats": ["anxiety", "insomnia"],
		"potency": 1,
		"unlock_day": 1,
	},
	"wormwood_draught": {
		"name": "Wormwood Draught",
		"description": "Bitter. Effective for stomach ailments. The taste lingers.",
		"ingredients": {"wormwood_leaf": 1, "thornroot_extract": 1},
		"treats": ["stomach_pain", "nausea"],
		"potency": 2,
		"unlock_day": 4,  # found in journal page 1
	},
	"strong_hearthbloom": {
		"name": "Concentrated Hearthbloom",
		"description": "Double-strength. For grief, not just nerves.",
		"ingredients": {"hearthbloom_petals": 3},
		"treats": ["grief", "anxiety", "insomnia"],
		"potency": 3,
		"unlock_day": 8,
	},
}

# Ailment display names
const AILMENTS := {
	"fever":        {"name": "Fever",         "symptoms": ["hot to touch", "sweating", "flushed skin"]},
	"headache":     {"name": "Headache",       "symptoms": ["head pain", "light sensitivity", "nausea"]},
	"anxiety":      {"name": "Anxiety",        "symptoms": ["restlessness", "racing heart", "can't sleep"]},
	"insomnia":     {"name": "Insomnia",       "symptoms": ["can't sleep", "exhaustion", "irritability"]},
	"stomach_pain": {"name": "Stomach Pain",   "symptoms": ["cramping", "nausea", "loss of appetite"]},
	"nausea":       {"name": "Nausea",         "symptoms": ["nausea", "dizziness", "pale complexion"]},
	"grief":        {"name": "Grief",          "symptoms": ["exhaustion", "loss of appetite", "can't sleep"]},
}

static func get_recipe(id: String) -> Dictionary:
	return RECIPES.get(id, {})

static func recipes_for_ailment(ailment: String) -> Array:
	var result: Array = []
	for rid: String in RECIPES:
		var r: Dictionary = RECIPES[rid]
		if ailment in r.get("treats", []):
			result.append(rid)
	return result

static func get_ailment(id: String) -> Dictionary:
	return AILMENTS.get(id, {})
