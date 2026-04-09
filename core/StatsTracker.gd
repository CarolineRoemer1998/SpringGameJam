extends Node

# Stats to track
# Steps
# Plants collected
# Plants that died
# You sneezed X times
# Final Score (whatever that means)

var Stats = {
	"Steps" : 0,
	"Plants Collected" : 0,
	"Plants that died" : 0,
	"Sneezes" : 0,
	"Final Score" : 0,
}

func _ready() -> void:
	SignalBus.stepped.connect(track_steps)
	
func track_steps():
	var steps = Stats.get("Steps")
	steps += 1
	Stats.set("Steps", steps)
	print("steps: ", Stats.get("Steps"))
