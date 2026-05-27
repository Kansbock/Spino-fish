extends CharacterBody2D

@export var bottom_speed := 120.0
@export var mid_speed := 200.0
@export var bottom_y_offset := 60.0

var direction := 1
var phase := 1
var last_direction := 0

func _ready():
	_place_for_phase()

func _place_for_phase():
	var screen_size = get_viewport_rect().size
	if phase == 1:
		global_position.y = screen_size.y + bottom_y_offset
		global_position.x = -300 if direction == 1 else screen_size.x + 300
	else:
		global_position.y = screen_size.y / 2.0
		global_position.x = -300 if direction == 1 else screen_size.x + 300

func _physics_process(delta):
	var screen_size = get_viewport_rect().size

	if phase == 1:
		global_position.y = screen_size.y + bottom_y_offset
		velocity.x = bottom_speed * direction
		move_and_slide()

		if global_position.x < -400 or global_position.x > screen_size.x + 400:
			direction = -direction
			phase = 2
			_place_for_phase()
	else:
		velocity.x = mid_speed * direction
		move_and_slide()

		if global_position.x < -400 or global_position.x > screen_size.x + 400:
			queue_free()

	if direction != last_direction:
		scale.x = -direction
		last_direction = direction
