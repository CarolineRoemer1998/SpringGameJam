extends StaticBody2D
class_name Plant

enum PLANT_TYPE {Daisy, Tulip, Sunflower}

@export var plant_data: PlantData

@onready var visual:AnimatedSprite2D = $AnimatedSprite2D
@onready var progressLabel:Label = $Control/Panel
@onready var control: Control = $Control

const pollen = preload("uid://c6oott1jjxued")
var plantState: Enums.plantStates = Enums.plantStates.SPROUT
var current_phase:int = 0
signal updated_phase(phase:int)

func _ready() -> void:
	set_type()
	print("initial state: ", Enums.plantStates.find_key(plantState))
	SignalBus.stepped.connect(on_stepped)
	SignalBus.flower_collected.connect(get_picked)
	
	#this should probably go into a setup function
	visual.set_animation("growing")
	visual.set_frame(0)

func set_type():
	plant_data = GameManager.get_and_use_current_seed().duplicate(true)
	visual.sprite_frames = plant_data.sprite_frames.duplicate(true)
	control.set_growth_panel()

func on_stepped(player_position):
	if player_position == global_position and plantState==Enums.plantStates.SPROUT:
		update_plant_state(Enums.plantStates.DEAD)
	
	match plantState:
		Enums.plantStates.SPROUT:
			current_phase += 1
			
			# if current phase is smaller or equal last grow phase, change state to sprout
			if current_phase <= plant_data.last_grow_phase:
				update_plant_state(Enums.plantStates.SPROUT)
			
			# if current phase is smaller than last grow phase and lower than allergy phase, change state to fully grown
			if current_phase > plant_data.last_grow_phase && current_phase < plant_data.allergy_phase:
				update_plant_state(Enums.plantStates.FULLY_GROWN)
				#modulate = Color(2.0, 1.0, 1.0)
			
			updated_phase.emit(current_phase)
			update_label()
		
		Enums.plantStates.FULLY_GROWN:
			current_phase += 1
			# if current phase equals or is higher than allergy phase, change state appropriately, change state to allergies
			if current_phase >= plant_data.allergy_phase:
				update_plant_state(Enums.plantStates.ALLERGIES)
			
			updated_phase.emit(current_phase)
			update_label()

		Enums.plantStates.ALLERGIES:
			pass
			
		Enums.plantStates.DEAD:
			pass
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
			global_position[1] += 2
			visual.set_animation("dead")
			control.visible = false
			print("set animation to dead")
	
		Enums.plantStates.FULLY_GROWN:
			visual.set_animation("fully grown")

		Enums.plantStates.ALLERGIES:
			#visual.modulate = Color(1.5, 1.5, 0.0) # Temporary visual for allergical
			var new_pollen = pollen.instantiate()
			add_child(new_pollen)
			new_pollen.global_position = global_position
			
			var directions = [Vector2(0,-1) , Vector2(0,1) , Vector2(1,0) , Vector2(-1,0)]
			const tile:float = 16
			for i in directions:
				var pos = global_position + i * tile
				if check_if_field_is_on_grid(pos) and not check_if_field_has_pollen(pos):
					var new_pollens = pollen.instantiate()
					add_child(new_pollens)
					new_pollens.global_position = global_position + i * tile
			
			
			#print("Doing allergies, but no code yet")

func get_picked(plant: Plant):
	if plant == self:
		queue_free()

func update_label():
	progressLabel.text = str(current_phase)

func check_if_field_is_on_grid(pos: Vector2) -> bool:
	return pos[0] >= Grid.GRID_X_MIN and pos[0] <= Grid.GRID_X_MAX and pos[1] >= Grid.GRID_Y_MIN and pos[1] <= Grid.GRID_Y_MAX

func check_if_field_has_pollen(pos: Vector2) -> bool:
	var result = Helper.check_for_collider_on_position(pos, (1 << Helper.LAYER_BIT_POLLEN), get_world_2d()) != null
	return result
