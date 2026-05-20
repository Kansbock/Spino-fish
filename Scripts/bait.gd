extends CharacterBody2D

@export var min := 40.0
@export var max := 550.0

@onready var player = get_node("/root/Scene/Player")
var fish = false

func _physics_process(delta):
	var mouse_y = get_global_mouse_position().y

	var min_y = player.global_position.y + min
	var max_y = player.global_position.y + max

	var target_y = clamp(mouse_y, min_y, max_y)

	global_position.y = lerp(global_position.y, target_y, 0.2)

func _on_area_2d_body_entered(body):

	if body.is_in_group("log"):
		if fish:
			for fish_node in get_tree().get_nodes_in_group("fish"):
				if fish_node.target == self and fish_node.caught:
					fish_node.fall_down()

			fish = false
	elif body.is_in_group("fish"):
		if fish:
			return
		body.catch(self)
		fish = true
