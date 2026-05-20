extends CharacterBody2D

@export var max_speed := 400.0
@export var min_speed := 100.0
var direction := 1 

func _physics_process(delta):
	var screen_size = get_viewport_rect().size.x
	
	var t = global_position.x / screen_size
	
	var speed_factor = abs(2 * t - 1)
	var current_speed = lerp(min_speed, max_speed, speed_factor)
	
	velocity.x = current_speed * direction
	move_and_slide()

	if global_position.x < -400 or global_position.x > screen_size + 400:
		queue_free()
