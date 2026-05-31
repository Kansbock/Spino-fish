extends Label

func _ready() -> void:
	# Começa mostrando zero
	text = "Pontuação Final: 0"
	
	# Inicia a animação de contagem
	contar_pontos()

func contar_pontos() -> void:
	var tween = create_tween()
	
	var pontuacao_final = GameManager.score
	
	tween.tween_method(atualizar_texto, 0, pontuacao_final, 1.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func atualizar_texto(valor_atual: int) -> void:
	text = "Pontuação Final: " + str(valor_atual)
