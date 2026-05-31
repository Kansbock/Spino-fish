extends CharacterBody2D

@export var min := 40.0
@export var max := 550.0
@export var restore_y_threshold := 200.0

@onready var player = get_node("/root/Scene/Player")
var fish = false
var lost := false

func _ready():
	add_to_group("bait")

func _physics_process(delta):
	var mouse_y = get_global_mouse_position().y

	var min_y = player.global_position.y + min
	var max_y = player.global_position.y + max

	var target_y = clamp(mouse_y, min_y, max_y)

	global_position.y = lerp(global_position.y, target_y, 0.2)

	if lost and global_position.y < restore_y_threshold and Input.is_action_just_pressed("click"):
		_restore_bait()

func _on_area_2d_body_entered(body):
	if lost:
		return

	if body.is_in_group("liopleurodon"):
		if not body.is_return:
			return
		GameManager.lose_life()
		_drop_caught_fish()
		_lose_bait()
		return

	if body.is_in_group("dunkleo"):
		if not fish:
			return
		_consume_caught_fish()
		GameManager.add_score(45)
		
		# Destrói o corpo de forma segura após o cálculo da física
		body.call_deferred("queue_free")
		
		# Muda de cena de forma segura após o cálculo da física
		get_tree().call_deferred("change_scene_to_file", "res://results.tscn")
		return

	if body.is_in_group("log"):
		if fish:
			_drop_caught_fish()
	elif body.is_in_group("fish"):
		if fish:
			return
		body.catch(self)
		fish = true

# Aproveitando para deixar a destruição dos peixes mais segura também:
func _consume_caught_fish():
	if not fish:
		return
	for fish_node in get_tree().get_nodes_in_group("fish"):
		if fish_node.target == self and fish_node.caught:
			# Usa call_deferred aqui também para evitar problemas com outros peixes
			fish_node.call_deferred("queue_free")
	fish = false

func _drop_caught_fish():
	if not fish:
		return
	for fish_node in get_tree().get_nodes_in_group("fish"):
		if fish_node.target == self and fish_node.caught:
			fish_node.fall_down()
	fish = false

func _lose_bait():
	lost = true
	$Sprite2D.visible = false
	$Area2D.set_deferred("monitoring", false)

func _restore_bait():
	lost = false
	$Sprite2D.visible = true
	$Area2D.set_deferred("monitoring", true)
