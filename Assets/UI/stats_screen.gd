extends Control

@onready var steps_stat: Label = $HBoxContainer/VBoxContainer2/Steps_Stat
@onready var flowers_collected_stat: Label = $"HBoxContainer/VBoxContainer2/Flowers Collected_Stat"
@onready var sad_flowers_stat: Label = $"HBoxContainer/VBoxContainer2/Sad Flowers_Stat"
@onready var sneezes_stat: Label = $HBoxContainer/VBoxContainer2/Sneezes_Stat
@onready var score__stat: Label = $"HBoxContainer/VBoxContainer2/Score?_Stat"

func _ready() -> void:
	SignalBus.updated_stats.connect(update_visuals)

func update_visuals(stats: Dictionary):
	#print(stats)
	steps_stat.set_text(str(stats.get("Steps")))
	flowers_collected_stat.set_text(str(stats.get("Plants Collected")))
	sad_flowers_stat.set_text(str(stats.get("Dead Plants")))
	sneezes_stat.set_text(str(stats.get("Sneezes")))
	score__stat.set_text(str(stats.get("Final Score")))
