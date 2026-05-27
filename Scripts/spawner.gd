extends Node2D

@export var coel_scene: PackedScene
@export var salmon_scene: PackedScene
@export var ichthy_scene: PackedScene
@export var liopleurodon_scene: PackedScene
@export var object_scene: PackedScene
@export var spawn_interval := 2.0
@export var direction := 1
var rng = RandomNumberGenerator.new()

func _ready():
	if GameManager.level == 1:
		spawn_loop()

func spawn_loop():
	if direction == 1 :
		await get_tree().create_timer(1).timeout
		var ichthy = ichthy_scene.instantiate()
		get_tree().current_scene.add_child(ichthy)
		ichthy.global_position = Vector2(-300, 375)
	while GameManager.fish < 15:
		await get_tree().create_timer(spawn_interval).timeout
		spawn()
	if direction == 1 :
		GameManager.change_level()
		await get_tree().create_timer(2).timeout
		await get_tree().create_timer(1).timeout
		var ichthy = ichthy_scene.instantiate()
		get_tree().current_scene.add_child(ichthy)
		ichthy.global_position = Vector2(-300, 375)
	while GameManager.fish < 45:
		await get_tree().create_timer(spawn_interval).timeout
		spawn_level2()
func spawn():
	var random_int = rng.randi_range(0, 100)
	if random_int < 30 :
		GameManager.fish += 1
		var coel = coel_scene.instantiate()
		get_tree().current_scene.add_child(coel)
	
		var screen_size = get_viewport_rect().size
		
		var y = randf_range(230, screen_size.y - 90)

		if direction == 1:
			coel.global_position = Vector2(-50, y)
			coel.direction = 1
		else:
			coel.global_position = Vector2(screen_size.x + 50, y)
			coel.direction = -1
	if random_int > 45 && random_int <= 65 :
		GameManager.fish += 1
		var salmon = salmon_scene.instantiate()
		get_tree().current_scene.add_child(salmon)
	
		var screen_size = get_viewport_rect().size
		
		var y = randf_range(230, screen_size.y - 90)

		if direction == 1:
			salmon.global_position = Vector2(-50, y)
			salmon.direction = 1
		else:
			salmon.global_position = Vector2(screen_size.x + 50, y)
			salmon.direction = -1
	if random_int >= 30 && random_int <= 45 :
		var log = object_scene.instantiate()
		get_tree().current_scene.add_child(log)
	
		var screen_size = get_viewport_rect().size
		
		var y = randf_range(300, screen_size.y - 50)

		if direction == 1:
			log.global_position = Vector2(-50, y)
			log.direction = 1
		else:
			log.global_position = Vector2(screen_size.x + 50, y)
			log.direction = -1
	if random_int > 0 && random_int <= 100: # Atenção a essa linha (veja a dica abaixo)
		GameManager.fish += 1
		var liopleurodon = liopleurodon_scene.instantiate()
		
		# Define a direção antes de entrar na cena
		liopleurodon.direction = 1 if direction == 1 else -1
		
		# Adiciona na cena (ele vai se posicionar sozinho no fundo usando o próprio _ready)
		get_tree().current_scene.add_child(liopleurodon)
func spawn_level2():
	var random_int = rng.randi_range(0, 100)
	if random_int < 30 :
		GameManager.fish += 1
		var coel = coel_scene.instantiate()
		get_tree().current_scene.add_child(coel)
	
		var screen_size = get_viewport_rect().size
		
		var y = randf_range(230, screen_size.y - 90)

		if direction == 1:
			coel.global_position = Vector2(-50, y)
			coel.direction = 1
		else:
			coel.global_position = Vector2(screen_size.x + 50, y)
			coel.direction = -1
	if random_int > 45 && random_int <= 65 :
		GameManager.fish += 1
		var salmon = salmon_scene.instantiate()
		get_tree().current_scene.add_child(salmon)
	
		var screen_size = get_viewport_rect().size
		
		var y = randf_range(230, screen_size.y - 90)

		if direction == 1:
			salmon.global_position = Vector2(-50, y)
			salmon.direction = 1
		else:
			salmon.global_position = Vector2(screen_size.x + 50, y)
			salmon.direction = -1
	if random_int > 65 && random_int <= 70: # Atenção a essa linha (veja a dica abaixo)
		GameManager.fish += 1
		var liopleurodon = liopleurodon_scene.instantiate()
		
		# Define a direção antes de entrar na cena
		liopleurodon.direction = 1 if direction == 1 else -1
		
		# Adiciona na cena (ele vai se posicionar sozinho no fundo usando o próprio _ready)
		get_tree().current_scene.add_child(liopleurodon)
	if random_int >= 30 && random_int <= 45 :
		var log = object_scene.instantiate()
		get_tree().current_scene.add_child(log)
	
		var screen_size = get_viewport_rect().size
		
		var y = randf_range(300, screen_size.y - 50)

		if direction == 1:
			log.global_position = Vector2(-50, y)
			log.direction = 1
		else:
			log.global_position = Vector2(screen_size.x + 50, y)
			log.direction = -1
