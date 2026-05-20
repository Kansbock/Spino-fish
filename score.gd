extends Label


func _ready():
	GameManager.connect("score_changed", _on_score_changed)

func _on_score_changed(new_score):
	text = "Peixes: " + str(new_score)
