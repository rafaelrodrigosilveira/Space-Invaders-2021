extends Node

var score = 0
var lifes = 3

# EXIBE SCORE DOS ALIENS MORTOS (PONTUAÇAO)
func _ready():
	randomize() # torna os tiros mais aleatorios
	update_score() #chama a funçao que exibe score na tela
	get_node("Alien_group").connect("enemy_down", self, "on_alien_group_enemy_down")
	get_node("Alien_group").connect("ready", self, "on_alien_group_ready")
	get_node("ship").connect("destroied", self, "on_ship_destroied") # conecta sinal nave destruida
	get_node("ship").connect("respawn", self, "on_ship_respawn") # conecta sinal nave destruida

func on_alien_group_enemy_down(alien):
	score += alien.score # soma os aliens mortos aumentando score
	update_score() #chama a funçao que exibe score na tela
	# print(alien.score)
# FIM - EXIBE SCORE DOS ALIENS MORTOS (PONTUAÇAO)

func on_alien_group_ready():
	get_node("ship").start()

func update_score():
	get_node("HUD/score").set_text(str(score)) # altera o LABEL exibindo o score na tela

func on_ship_destroied():
	# print("on_ship_destroied")
	get_node("Alien_group").stop_all() #para tudo quando a nave explode
	
	# DIMINUI A VIDA QUANDO MORRE
	lifes -= 1
	get_node("HUD/life_draw").lifes = lifes #atualiza o objeto

func on_ship_respawn():
	get_node("Alien_group").start_all()