extends StaticBody2D
class_name Plant

@export var PlantName:String
@export var last_grow_Phase:int
@export var allergyPhase:int

@onready var visual:Sprite2D = $Sprite2D
@onready var progressLabel:Label = $Control/Panel

@export var growStageSprites:Array[CompressedTexture2D]

var plantState: Enums.plantStates
var current_phase:int = 0

func _ready() -> void:
	SignalBus.stepped.connect(on_stepped)
	SignalBus.flower_collected.connect(disappear)
	
func on_stepped():
	current_phase += 1
	update_label()
	
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

func disappear(plant: Plant):
	if plant != self:
		return
	
	queue_free()

func update_label():
	progressLabel.text = str(current_phase)
