extends CharacterBody2D

@export var speed := 100.0
var direction := 1 
var target = null
var last_direction := 0
@export var sprite1: Texture2D
@export var sprite2: Texture2D

func _ready():
	add_to_group("log")
	var sprite = $Sprite2D
	var collision = $CollisionShape2D
	
	# escolhe aleatoriamente
	if randi() % 2 == 0:
		sprite.texture = sprite1
	else:
		sprite.texture = sprite2


func _physics_process(delta):
	velocity.x = speed * direction
	move_and_slide()

	var screen_size = get_viewport_rect().size
	
	if global_position.x < -50 or global_position.x > screen_size.x + 100:
		queue_free()

	# virar sprite
	if direction != last_direction:
		scale.x = -direction
		last_direction = direction
