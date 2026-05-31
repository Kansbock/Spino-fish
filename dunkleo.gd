extends CharacterBody2D

@export var speed := 80.0
@export var height_multiplier := 0.6

var direction := 1
var last_direction := 0

func _ready():
	add_to_group("dunkleo")
	var screen_size = get_viewport_rect().size
	global_position.y = screen_size.y * height_multiplier
	global_position.x = -300 if direction == 1 else screen_size.x + 300
	scale.x = -direction
	last_direction = direction

func _physics_process(_delta):
	var screen_size = get_viewport_rect().size

	velocity.x = speed * direction
	move_and_slide()

	if direction != last_direction:
		scale.x = -direction
		last_direction = direction

	if global_position.x < -400 or global_position.x > screen_size.x + 400:
		get_tree().change_scene_to_file("res://results.tscn")
		queue_free()
