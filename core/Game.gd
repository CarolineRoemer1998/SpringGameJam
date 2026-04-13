extends Node2D
class_name Game

@onready var game_over_screen = $GameOverScreen


func _ready():
	SignalBus.game_over.connect(set_game_over)
	game_over_screen.visible = false
	
func set_game_over():
	game_over_screen.visible = true
