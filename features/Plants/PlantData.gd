extends Node2D
class_name Plant

@export var PlantName:String
@export var visual:Image
@export var last_grow_Phase:int
@export var allergyPhase:int

var plantState: Enums.plantStates
var current_phase:int = 0

func _ready() -> void:
	SignalBus.stepped.connect(on_stepped)
	
func on_stepped():
	current_phase += 1

	# if current phase is smaller or equal last grow phase, change state to sprout
	if current_phase <= last_grow_Phase:
		update_plant_state(Enums.plantStates.SPROUT)
	
	# if current phase is smaller than last grow phase and lower than allergy phase, change state to fully grown
	if current_phase > last_grow_Phase && current_phase < allergyPhase:
		update_plant_state(Enums.plantStates.FULLY_GROWN)
	
	# if current phase equals or is higher than allergy phase, change state appropriately, change state to allergies
	if current_phase <= allergyPhase:
		update_plant_state(Enums.plantStates.ALLERGIES)
		
func update_plant_state(state:Enums.plantStates):
	plantState = state
	SignalBus.plant_changed_state.emit(self,state)
	
	# change visuals
	# if state changes to allergies, do explosions
