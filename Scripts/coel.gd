extends CharacterBody2D

@export var speed := 100.0
var direction := 1 
var caught = false
var target = null
var last_direction := 0
var falling := false
@export var fall_speed := 400.0

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

	
func _physics_process(delta):
	if falling:
		velocity.y = fall_speed
		move_and_slide()

		var screen_size = get_viewport_rect().size
		if global_position.y > screen_size.y + 50:
			queue_free()
		return
	if target and caught and global_position.y < 200 and Input.is_action_just_pressed("click"):
			target.fish = false
			GameManager.add_score()
			queue_free()
	if caught and target:
		global_position = target.global_position + Vector2(0, 10)
		rotation = deg_to_rad(90)
		z_as_relative = false
		z_index = 100
		return
	velocity.x = speed * direction
	move_and_slide()

	var screen_size = get_viewport_rect().size
	
	if global_position.x < -50 or global_position.x > screen_size.x + 100:
		queue_free()
	if direction != last_direction:
		scale.x = -direction
		last_direction = direction
	
