extends Node2D
class_name Plant

@export var PlantName:String
@export var last_grow_Phase:int
@export var allergyPhase:int

@onready var visual:AnimatedSprite2D = $AnimatedSprite2D
@onready var progressLabel:Label = $Control/Panel

var plantState: Enums.plantStates = Enums.plantStates.SPROUT
var current_phase:int = 0

func _ready() -> void:
	SignalBus.stepped.connect(on_stepped)
	on_stepped()
	
func on_stepped():
	if current_phase != Enums.plantStates.DEAD:
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
	print("updating state: ", state)
	plantState = state
	SignalBus.plant_changed_state.emit(self,state)
	
	# if plant is growing pick the matching frame from the sprite sheet and set it
	if plantState == Enums.plantStates.SPROUT:
		visual.set_animation("growing")
		var index:int
		if current_phase <= visual.sprite_frames.get_frame_count("growing"):
			index = current_phase - 1
		else:
			index = visual.sprite_frames.get_frame_count("growing")
		visual.set_frame(index)
		print("current frame:", visual.get_frame())
	
	# if plant is dead switch animation
	if current_phase == Enums.plantStates.DEAD:
		visual.set_animation("dead")
		print("set animation to dead")
	
	# if state changes to allergies, do explosions
	
	# Let everybody know this plant did something
	SignalBus.plant_changed_state.emit(self, state)

func update_label():
	progressLabel.text = str(current_phase)
