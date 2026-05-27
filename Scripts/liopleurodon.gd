extends CharacterBody2D

@export var bottom_speed := 120.0
@export var mid_speed := 100.0
@export var bottom_y_offset := 60.0

# Novas variáveis para facilitar o ajuste das áreas de retorno no Inspector
@export var area_1_height_multiplier := 0.6  # 50% da tela (Meio)
@export var area_2_height_multiplier := 0.8 # 25% da tela (Mais para cima)

var direction := 1
var phase := 1
var last_direction := 0
var return_path := 0 # Variável para guardar a escolha aleatória

func _ready():
	_place_for_phase()

func _place_for_phase():
	var screen_size = get_viewport_rect().size
	
	if phase == 1:
		global_position.y = screen_size.y + bottom_y_offset
		global_position.x = -300 if direction == 1 else screen_size.x + 300
	else:
		# Verifica qual caminho foi sorteado para definir a altura
		if return_path == 0:
			global_position.y = screen_size.y * area_1_height_multiplier
		else:
			global_position.y = screen_size.y * area_2_height_multiplier
			
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
			
			# Sorteia um número entre 0 e 1 ANTES de rodar a função de reposição
			return_path = randi() % 2 
			
			_place_for_phase()
	else:
		velocity.x = mid_speed * direction
		move_and_slide()

		if global_position.x < -400 or global_position.x > screen_size.x + 400:
			queue_free()

	if direction != last_direction:
		$Sprite2D.flip_h = (direction == 1) # Inverte o visual
		
		# Inverte a posição (offset) da colisão no eixo X
		$CollisionShape2D.position.x = -$CollisionShape2D.position.x 
		last_direction = direction
