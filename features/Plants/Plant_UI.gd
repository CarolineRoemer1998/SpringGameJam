extends Control

@onready var plant: Plant = $".."
@onready var growth_progress_bar: ProgressBar = $GrowthProgressBar
@onready var pollen_progress_bar: ProgressBar = $PollenProgressBar

func _ready() -> void:
	growth_progress_bar.set_value_no_signal(0)
	growth_progress_bar.min_value = 0
	growth_progress_bar.max_value = plant.plant_data.allergy_phase

func _on_plant_updated_phase(phase: int) -> void:
	growth_progress_bar.set_value(phase)
	
	# match plant state, change color
	match plant.plantState:
		Enums.plantStates.SPROUT:
			growth_progress_bar.self_modulate = Color(1.0, 1.0, 0.0, 1.0)
		Enums.plantStates.FULLY_GROWN:
			growth_progress_bar.self_modulate = Color(0.0, 1.0, 0.0, 1.0)
		Enums.plantStates.ALLERGIES:
			print("deleting myself")
			queue_free()
		Enums.plantStates.DEAD:
			queue_free()
