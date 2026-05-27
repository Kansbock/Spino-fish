extends Node

var score := 0
var level :=1
var fish :=0
signal score_changed
signal next_level

func add_score(score):
	score += score
	emit_signal("score_changed", score)

func change_level():
	level += 1
	print("Mudou fase para:", level)
	emit_signal("next_level", level)
