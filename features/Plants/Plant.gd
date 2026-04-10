extends StaticBody2D
class_name Plant

@export var PlantName:String
@export var last_grow_Phase:int=3
@export var allergyPhase:int=5

@onready var visual:AnimatedSprite2D = $AnimatedSprite2D
@onready var progressLabel:Label = $Control/Panel

var plantState: Enums.plantStates = Enums.plantStates.SPROUT
var current_phase:int = 0

func _ready() -> void:
	print("initial state: ", Enums.plantStates.find_key(plantState))
	SignalBus.stepped.connect(on_stepped)
	SignalBus.flower_collected.connect(get_picked)
	
	#this should probably go into a setup function
	visual.set_animation("growing")
	visual.set_frame(0)
	
	#on_stepped()
	
func on_stepped():
	match plantState:
		Enums.plantStates.DEAD:
			update_plant_state(Enums.plantStates.DEAD)
			
		Enums.plantStates.SPROUT:
			#sprint("stepping as sprout")
			current_phase += 1
			update_label()
			
			# if current phase is smaller or equal last grow phase, change state to sprout
			if current_phase <= last_grow_Phase:
				update_plant_state(Enums.plantStates.SPROUT)
			
			# if current phase is smaller than last grow phase and lower than allergy phase, change state to fully grown
			if current_phase > last_grow_Phase && current_phase < allergyPhase:
				update_plant_state(Enums.plantStates.FULLY_GROWN)
			
			
		Enums.plantStates.FULLY_GROWN:
			current_phase += 1
			update_label()
			# if current phase equals or is higher than allergy phase, change state appropriately, change state to allergies
			if current_phase >= allergyPhase:
				update_plant_state(Enums.plantStates.ALLERGIES)
		_:
			print("no plant State match found")

func update_plant_state(state:Enums.plantStates):
	print("updating state: ", Enums.plantStates.find_key(state))
	plantState = state
	SignalBus.plant_changed_state.emit(self,state)
	
	# if plant is growing pick the matching frame from the sprite sheet and set it
	match plantState:
		Enums.plantStates.SPROUT:
			visual.set_animation("growing")
			var index:int
			if current_phase <= visual.sprite_frames.get_frame_count("growing"):
				index = current_phase
			else:
				index = visual.sprite_frames.get_frame_count("growing")
			visual.set_frame(index)
			print("current frame:", visual.get_frame())
		
		Enums.plantStates.DEAD:
			visual.set_animation("dead")
			print("set animation to dead")
	
		Enums.plantStates.FULLY_GROWN:
			visual.set_animation("fully grown")

		Enums.plantStates.ALLERGIES:
			visual.modulate = Color(1.5, 1.5, 0.0) # Temporary visual for allergical
			print("Doing allergies, but no code yet")

func get_picked(plant: Plant):
	if plant == self:
		queue_free()

func update_label():
	progressLabel.text = str(current_phase)
