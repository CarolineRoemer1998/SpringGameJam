extends Control
class_name PlantUI

@onready var plant: Plant = $".."
@onready var growth_progress_bar: ProgressBar = $GrowthProgressBar
@onready var pollen_progress_bar: ProgressBar = $PollenProgressBar

var state = Enums.plantStates.SPROUT

func set_growth_panel():
	growth_progress_bar.set_value_no_signal(0)
	growth_progress_bar.min_value = 0
	growth_progress_bar.max_value = plant.plant_data.last_grow_phase+1
	print("###### ", growth_progress_bar.max_value)

func _on_plant_updated_phase(phase: int) -> void:
	match plant.plantState:
		Enums.plantStates.SPROUT:
			growth_progress_bar.self_modulate = Color(1.0, 1.0, 0.0, 1.0)
			growth_progress_bar.value = phase

		Enums.plantStates.FULLY_GROWN:
			var fully_grown_start_phase = plant.plant_data.last_grow_phase + 1
			var fully_grown_duration = plant.plant_data.allergy_phase - fully_grown_start_phase

			if state == Enums.plantStates.SPROUT:
				state = Enums.plantStates.FULLY_GROWN
				growth_progress_bar.value = 0
				growth_progress_bar.max_value = fully_grown_duration-1
			else:
				growth_progress_bar.value = clamp(
					phase - fully_grown_start_phase,
					0,
					fully_grown_duration
				)

			growth_progress_bar.self_modulate = Color(0.0, 1.0, 0.0, 1.0)

		Enums.plantStates.ALLERGIES:
			queue_free()

		Enums.plantStates.DEAD:
			queue_free()
