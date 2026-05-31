extends CharacterBody2D

@export var bottom_speed := 240.0
@export var mid_speed := 280.0
@export var bottom_y_offset := 60.0

# Áreas de retorno (altura em fração da tela)
@export var area_1_height_multiplier := 0.6
@export var area_2_height_multiplier := 0.8

const LIOPLEURODON_SCENE := preload("res://liopleurodon.tscn")

var direction := 1
var last_direction := 0
var is_return := false
var return_path := 0  

func _ready():
	add_to_group("liopleurodon")
	_place_for_phase()
	scale.x = -direction
	last_direction = direction

func _place_for_phase():
	var screen_size = get_viewport_rect().size

	if not is_return:
		global_position.y = screen_size.y + bottom_y_offset
	else:
		# Segunda passada: aparece visível em 0.6 ou 0.8 da altura
		if return_path == 0:
			global_position.y = screen_size.y * area_1_height_multiplier
		else:
			global_position.y = screen_size.y * area_2_height_multiplier

	global_position.x = -300 if direction == 1 else screen_size.x + 300

func _physics_process(delta):
	var screen_size = get_viewport_rect().size

	if not is_return:
		# Mantém na parte de baixo (fora da tela)
		global_position.y = screen_size.y + bottom_y_offset
		velocity.x = bottom_speed * direction
	else:
		velocity.x = mid_speed * direction

	move_and_slide()

	if direction != last_direction:
		scale.x = -direction
		last_direction = direction

	# Saiu da tela
	if global_position.x < -400 or global_position.x > screen_size.x + 400:
		if not is_return:
			# Primeira passada acabou: spawna a segunda virada pro lado contrário
			_spawn_return()
		queue_free()

func _spawn_return():
	var new_liop = LIOPLEURODON_SCENE.instantiate()
	new_liop.direction = -direction
	new_liop.is_return = true
	new_liop.return_path = randi() % 2
	get_tree().current_scene.add_child(new_liop)
