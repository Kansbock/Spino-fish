extends Node

var score := 0
var level := 1
var fish := 0
var life := 3
signal score_changed
signal next_level
signal life_changed

func add_score(amount):
	score += amount
	emit_signal("score_changed", score)

func change_level():
	level += 1
	print("Mudou fase para:", level)
	emit_signal("next_level", level)

func lose_life():
	life -= 1
	print("Perdeu vida. Vidas restantes:", life)
	emit_signal("life_changed", life)
	if life <= 0:
		reset()
		get_tree().change_scene_to_file("res://menu.tscn")

func reset():
	score = 0
	level = 1
	fish = 0
	life = 3
