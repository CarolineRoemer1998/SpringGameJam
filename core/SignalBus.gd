# SignalBus.gd
extends Node

signal stepped(global_psotion:Vector2)
signal plant_changed_state(plant:Plant , state:Enums.plantStates)
signal seed_planted(pos: Vector2, plant_type: String) ##TODO: plant_type später zu enum oder ressource-type ändern
signal flower_collected(flower: Plant)
signal sneezed()
