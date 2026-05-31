extends Label


func _ready() -> void:
	GameManager.life_changed.connect(_on_life_changed)
	text = "Vidas: " + str(GameManager.life)


func _on_life_changed(new_life: int) -> void:
	text = "Vidas: " + str(new_life)
