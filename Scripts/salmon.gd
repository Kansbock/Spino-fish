extends CharacterBody2D

@export var speed := 100.0
@export var fall_speed := 400.0
@export var dodge_speed := 350.0
@export var dodge_detection_distance := 450.0
@export var dodge_vertical_threshold := 120.0
@export var hesitate_duration := 1.0
@export var hesitate_speed_factor := 0.12
@export var post_hesitate_speed := 300.0

var direction := 1
var caught = false
var target = null
var last_direction := 0
var falling := false

var dodging := false
var dodge_direction := 0
var dodge_target = null

var hesitating := false
var hesitate_timer := 0.0
var has_dodged := false

func fall_down():
	falling = true
	caught = false
	target = null
	rotation = deg_to_rad(180)
	velocity = Vector2.ZERO

func catch(bait):
	caught = true
	target = bait
	velocity = Vector2.ZERO

func _ready():
	add_to_group("fish")

func _find_bait_ahead():
	for bait in get_tree().get_nodes_in_group("bait"):
		if bait.fish:
			continue
		var dx = bait.global_position.x - global_position.x
		var dy = bait.global_position.y - global_position.y
		if sign(dx) == direction and abs(dx) < dodge_detection_distance and abs(dy) < dodge_vertical_threshold:
			return bait
	return null

func _physics_process(delta):
	if falling:
		velocity.y = fall_speed
		move_and_slide()
		if global_position.y > get_viewport_rect().size.y + 50:
			queue_free()
		return

	if target and caught and global_position.y < 200 and Input.is_action_just_pressed("click"):
		target.fish = false
		GameManager.add_score(2)
		queue_free()

	if caught and target:
		global_position = target.global_position + Vector2(0, 10)
		rotation = deg_to_rad(90)
		z_as_relative = false
		z_index = 100
		return

	var screen_size = get_viewport_rect().size

	# Verifica se ainda faz sentido continuar desviando
	if dodging:
		if not is_instance_valid(dodge_target):
			dodging = false
			dodge_direction = 0
			dodge_target = null
		else:
			var dx_to_bait = dodge_target.global_position.x - global_position.x
			if sign(dx_to_bait) != direction or abs(dx_to_bait) > dodge_detection_distance:
				dodging = false
				dodge_direction = 0
				dodge_target = null

	# Conta o tempo de hesitação antes de desviar de verdade
	if hesitating:
		if not is_instance_valid(dodge_target):
			hesitating = false
			hesitate_timer = 0.0
			dodge_target = null
		else:
			hesitate_timer += delta
			if hesitate_timer >= hesitate_duration:
				hesitating = false
				hesitate_timer = 0.0
				dodging = true
				has_dodged = true

	# Detecta isca à frente e inicia hesitação
	if not dodging and not hesitating:
		var bait = _find_bait_ahead()
		if bait:
			hesitating = true
			hesitate_timer = 0.0
			dodge_target = bait
			var dy = bait.global_position.y - global_position.y
			dodge_direction = -1 if dy >= 0 else 1

			var min_y = 240.0
			var max_y = screen_size.y - 100.0
			if dodge_direction == -1 and (global_position.y - min_y) < 80.0:
				dodge_direction = 1
			elif dodge_direction == 1 and (max_y - global_position.y) < 80.0:
				dodge_direction = -1

	var effective_speed = speed * hesitate_speed_factor if hesitating else (post_hesitate_speed if (dodging or has_dodged) else speed)

	velocity.x = effective_speed * direction

	var spawn_min_y = 230.0
	var spawn_max_y = screen_size.y - 90.0

	if dodging:
		var vy = dodge_speed * dodge_direction
		if dodge_direction == -1 and global_position.y <= spawn_min_y:
			vy = 0.0
		elif dodge_direction == 1 and global_position.y >= spawn_max_y:
			vy = 0.0
		velocity.y = vy
	else:
		velocity.y = 0.0

	move_and_slide()

	if global_position.x < -50 or global_position.x > screen_size.x + 100:
		queue_free()
	if direction != last_direction:
		scale.x = -direction
		last_direction = direction
