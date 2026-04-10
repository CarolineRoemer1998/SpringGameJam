extends Node

# Stats to track
# Steps
# Plants collected
# Plants that died
# You sneezed X times
# Final Score (whatever that means)

var Stats = {
	"Steps" : 0,
	"Plants Collected" : 0,
	"Dead Plants" : 0,
	"Sneezes" : 0,
	"Final Score" : 0,
}

func _ready() -> void:
	SignalBus.stepped.connect(track_steps)
	SignalBus.plant_collected.connect(track_plant_collection)
	SignalBus.plant_changed_state.connect(track_plant_states)
	SignalBus.sneezed.connect(track_sneezes)
	SignalBus.plant_collected.connect(track_plant_collection)
	
func track_steps():
	var steps = Stats.get("Steps")
	steps += 1
	Stats.set("Steps", steps)

func track_plant_collection():
	var plants_collected = Stats.get("Plants Collected")
	plants_collected += 1
	Stats.set("Plants Collected", plants_collected)

func track_plant_states(plant: Plant, state: Enums.plantStates):
	match state:
		Enums.plantStates.DEAD:
			var dead_plants = Stats.get("Dead Plants")
			dead_plants += 1
			Stats.set("Steps", dead_plants)
	
func track_sneezes():
	var sneezes = Stats.get("Sneezes")
	sneezes += 1
	Stats.set("Sneezes", sneezes)
	
