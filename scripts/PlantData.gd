extends Node

# Static plant species definitions. No autoload needed — accessed as PlantData.get_species().

const SPECIES := {
	"thornroot": {
		"name": "Thornroot",
		"description": "A stubborn root with bitter bark. Common base for fever and pain remedies.",
		"days_per_stage": 2,
		"yield_ingredient": "thornroot_extract",
		"yield_min": 1,
		"yield_max": 3,
		"water_need": 0.4,  # drains this much per day
	},
	"hearthbloom": {
		"name": "Hearthbloom",
		"description": "Warm orange flowers that calm the mind. Grandma grew them near the window.",
		"days_per_stage": 3,
		"yield_ingredient": "hearthbloom_petals",
		"yield_min": 2,
		"yield_max": 4,
		"water_need": 0.3,
	},
	"wormwood": {
		"name": "Wormwood",
		"description": "Silvery-green and intensely bitter. More uses than most apothecaries admit.",
		"days_per_stage": 4,
		"yield_ingredient": "wormwood_leaf",
		"yield_min": 1,
		"yield_max": 2,
		"water_need": 0.25,  # drought-tolerant
	},
	"moonleaf": {
		"name": "Moonleaf",
		"description": "Pale, almost luminescent. Grandma kept this plot locked. You don't know why yet.",
		"days_per_stage": 5,
		"yield_ingredient": "moonleaf_extract",
		"yield_min": 1,
		"yield_max": 1,
		"water_need": 0.5,
	},
}

static func get_species(id: String) -> Dictionary:
	return SPECIES.get(id, {})

static func get_all_ids() -> Array:
	return SPECIES.keys()
