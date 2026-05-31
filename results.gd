extends Control


func _on_restart_button_pressed() -> void:
	GameManager.reset()
	get_tree().change_scene_to_file("res://menu.tscn")
