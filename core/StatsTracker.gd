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
	SignalBus.flower_collected.connect(track_plant_collection)
	SignalBus.plant_changed_state.connect(track_plant_states)
	SignalBus.sneezed.connect(track_sneezes)
	
func track_steps(position: Vector2):
	var steps = Stats.get("Steps")
	steps += 1
	Stats.set("Steps", steps)
	SignalBus.updated_stats.emit(Stats)

func track_plant_collection(_flower:Plant):
	var plants_collected = Stats.get("Plants Collected")
	plants_collected += 1
	Stats.set("Plants Collected", plants_collected)
	SignalBus.updated_stats.emit(Stats)

func track_plant_states(plant: Plant, state: Enums.plantStates):
	match state:
		Enums.plantStates.DEAD:
			print("setting stats for dead")
			var dead_plants = Stats.get("Dead Plants")
			dead_plants += 1
			Stats.set("Dead Plants", dead_plants)
			SignalBus.updated_stats.emit(Stats)
	
func track_sneezes():
	var sneezes = Stats.get("Sneezes")
	sneezes += 1
	Stats.set("Sneezes", sneezes)
	SignalBus.updated_stats.emit(Stats)
