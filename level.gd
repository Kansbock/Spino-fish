extends Label


func _ready():
	GameManager.next_level.connect(_on_level_changed)
	text = "Fase: " + str(GameManager.level)

func _on_level_changed(newlevel):
	print("Label recebeu:", newlevel)
	text = "Fase: " + str(newlevel)
